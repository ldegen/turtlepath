{Record, Stack}=require "immutable"
StackFrame = Record
  position: [0,0]
  heading: 0 #i.e. up
  turnAngle: Math.PI/2 # 90 Degrees
  distance: 1
State = Record
  stack: Stack().push new StackFrame
  accumulator: [0,0]
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
    .bind updateTop "position", v_add accumulator
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
    .bind set "action", "move"
    .unwrap

draw = (state)->
  addDelta = v_add delta state
  wrap state
    .bind ite not_drawing, flush
    .bind update "accumulator", addDelta
    .bind updateTop "position", addDelta
    .bind set "action", "draw"
    .unwrap

push = (state, {stack,accumulator},{position})->
  # create a copy of the current frame.
  state.update "stack", (stack)->
    stack.push stack.peek()

pop = (state,{stack})->
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

reducer = (chain, opc)->chain.bind transforms[opc]
next = (f)->()->
  new Turtle wrap(this.state).bind(f).unwrap
module.exports = class Turtle
  constructor: (@state= new State)->
  draw: next draw
  push: next push
  pop: next pop
  left: next turn -1
  right: next turn 1
  move: next move
  path: (s="")->
    [s...]
      .reduce reducer, wrap @state
      .bind flush
      .unwrap
      .buffer
