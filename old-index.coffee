{Record, Stack, List}=require "immutable"
StackFrame = Record
  position: [0,0]
  heading: 0 #i.e. up
  turnAngle: Math.PI/2 # 90 Degrees
  distance: 1
  vertex: null
State = Record
  stack: Stack().push new StackFrame
  accumulator: [0,0]
  vertices: List()
  edges: List()
  action: "start"
  buffer: ""


append = (action, [x,y])->(buffer)->
  return buffer if x is 0 and y is 0 and action isnt "pop"
  space = (if buffer then " " else "")
  op = switch action
    when "draw" then "l"
    when "pop" then "M"
    when "move", "turn" then "m"
    else false
  if op then buffer+space+op+" "+x+" "+y else buffer

updateTop = (prop, update)->(state) ->
  state.update "stack", (stack)->
    stack.pop().push stack.peek().update prop, update

v_add = ([x1,y1])->([x0,y0])->[x0+x1,y0+y1]
s_add = (b)->(a)->a+b

delta = (state)->
  {heading,distance}=state.stack.peek()
  [distance*Math.sin(heading), -distance*Math.cos(heading)]



wrap = (state)->
  bind: (f)->
    wrap f state, state, state.stack.peek()
  unwrap: state



identity = (s)->s
c_eq = (prop, c )->(state)->c == state[prop]
c_neq = (prop, c )->(state)->c != state[prop]
drawing = c_eq "action", "draw"
not_drawing = c_neq "action", "draw"

set = (prop, val)->(state)->state.set prop, val
update = (prop, f)->(state)->state.update prop, f
ite = (cond0, thenBranch, elseBranch=identity)->(state)->
  cond = if typeof cond0 is "function" then cond0 state else cond0
  branch = if cond then thenBranch  else elseBranch
  wrap(state).bind(branch).unwrap



flush = (state,{accumulator, action})->
  return state if accumulator[0] is 0 and accumulator[1] is 0
  wrap state
    .bind set "accumulator", [0,0]
    .bind update "buffer", append action, accumulator
    .unwrap


turn = (sign)->(state,_,{turnAngle})->
  wrap state
    .bind ite drawing, flush
    .bind set "action", "turn"
    .bind updateTop "heading", s_add sign*turnAngle
    .unwrap

move = (state)->
  addDelta = v_add delta state
  wrap state
    .bind ite drawing, flush
    .bind update "accumulator", addDelta
    .bind updateTop "position", addDelta
    .bind updateTop "vertex", -> null
    .bind set "action", "move"
    .unwrap

# Is the current position that of a known vertex?
knownPosition = ({stack})->
  stack.peek().vertex?

# is the current vertex recorded as the last vertex
# of the most recent edge?
continuation = ({edges, stack})->
  v0 = edges.last()?.last()
  v1 = stack.peek().vertex

  v0? and v1? and v0 is v1



startEdgeAtKnownVertex = (state)->
  vertex = state.stack.peek().vertex
  wrap state
    .bind update "edges", (edge)->edge.push List [state.stack.peek().vertex]
    .unwrap

startEdgeAtNewVertex= (state,{vertices},{position})->
  wrap state
    .bind update "vertices", (vertices)->vertices.push position
    .bind updateTop "vertex", -> vertices.size
    .bind update "edges", (edges)->edges.push List [vertices.size]
    .unwrap

startEdge = (state,{vertices},{position})->
  wrap state
    .bind ite knownPosition, startEdgeAtKnownVertex, startEdgeAtNewVertex
    .unwrap

continueEdge = (to)->(state,{vertices})->
  wrap state
    .bind update "vertices", (vertices)->vertices.push to
    .bind updateTop "vertex", -> vertices.size
    .bind update "edges", (edges)->
      edges.pop().push edges.last().push vertices.size
    .unwrap
draw = (state, {vertices},{position})->
  addDelta = v_add delta state
  wrap state
    .bind ite not_drawing, flush
    .bind ite continuation, identity, startEdge
    .bind continueEdge addDelta position
    .bind update "accumulator", addDelta
    .bind updateTop "position", addDelta
    .bind set "action", "draw"
    .unwrap

push = (state, {stack})->
  # create a copy of the current frame.
  #console.log "push", stack.peek()
  state.update "stack", (stack)->
    stack.push stack.peek()

pop = (state,{stack})->
  #console.log "pop", stack.pop().peek()
  wrap state
    .bind ite drawing, flush
    .bind update "stack", (stack)->stack.pop()
    .bind update "buffer", append "pop", stack.pop().peek().position
    .bind set "action", "pop"
    .bind set "accumulator", [0,0]
    .unwrap

transforms =
  'F': draw
  'f': move
  '+': turn 1
  '-': turn -1
  '[': push
  ']': pop

reducer = (chain, opc)->
  {position, heading} =  chain.unwrap.stack.peek()
  {action, accumulator,vertices} = chain.unwrap
  chain.bind (transforms[opc] ? identity)
next = (f0)->(args...)->
  f = if args.length > 0 then f0 args... else f0
  new Turtle wrap(this.state).bind(f).unwrap

execute = (s)->(state)->
  [s...]
    .reduce reducer, wrap state
    .unwrap

module.exports = class Turtle
  constructor: (@state= new State)->
  draw: next draw
  push: next push
  pop: next pop
  left: next turn -1
  right: next turn 1
  move: next move
  distance: next (d)-> updateTop "distance", ->d
  turnAngle: next (a)-> updateTop "turnAngle", ->a
  exec: next execute
  vertices: ()->@state.vertices.toJS()
  edges: ()->@state.edges.toJS()
  points: ()->@vertices()
  path: ()->
    p= wrap @state
      .bind flush
      .unwrap
      .buffer
    "M 0 0 #{p}"
