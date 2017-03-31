Turtle = require "../src/index.coffee"

e = Math.cos Math.PI/2
f = Math.sin Math.PI
describe "The stateful turtle", ->
  
  it "turns the right way", ->
    path = new Turtle()
      .draw()
      .right()
      .draw()
      .path()
    expect(path).to.eql "M 0 0 l 0 -1 l 1 -#{e}"

  it "moves, if told to, without drawing", ->
    t = new Turtle()
      .move()
      .right()
      .move()
      .left()
      .draw()
    t2 = t
      .left()
      .move()
      .move()
      .left()
      .draw()
    expect(t.path()).to.eql "M 0 0 m 1 -1 l 0 -1"
    expect(t2.path()).to.eql "M 0 0 m 1 -1 l 0 -1 m -2 #{-f} l #{-f} 1"

  it "can use a LIFO to store and restore states", ->
    t = new Turtle()
      .draw()
      .push()
      .draw()
      .pop()
      .push()
      .left()
      .draw()
      .pop()
      .right()
      .draw()
    expect(t.path()).to.eql "M 0 0 l 0 -2 M 0 -1 l -1 #{-e} M 0 -1 l 1 #{-e}"

describe "The simple turtle", ->
  it "just follows a path described by a string", ->
    path = new Turtle()
      .exec "[fF]"
      .path()
    #path = new Turtle().path "[fF][+fF][-fF]--fF"
    expect(path).to.eql "M 0 0 m 0 -1 l 0 -1 M 0 0"

  it "handles nested push/pop calls", ->
    path = new Turtle()
      .exec "F[-F[+F][-F]]"
      .path()
    expect(path).to.eql "M 0 0 l 0 -1 l -1 #{-e} l 0 -1 M -1 -1 l #{-f} 1 M -1 -1 M 0 -1"

  it "can produce a list of vertices instead of a path", ->
    points = new Turtle()
      .exec "fFF++F-F"
      .points()
    expect(points).to.eql [
      [0,-1]
      [0,-2]
      [0,-3]
      [f,-2]
      [1.0000000000000002,-2]
    ]
