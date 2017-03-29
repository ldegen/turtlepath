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
    expect(path).to.eql "l 0 -1 l 1 -#{e}"

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
    expect(t.path()).to.eql "m 1 -1 l 0 -1"
    expect(t2.path()).to.eql "m 1 -1 l 0 -1 m -2 #{-f} l #{-f} 1"

describe "The simple turtle", ->
  xit "just follows a path described by a string", ->
    path = new Turtle().path "[fF][+fF][-fF]--fF"
    expect(path).to.eql "M 0 1 l #{f} 1 M 1 #{e} l 1 #{e} M -1 #{e} l -1 #{e} M 0 -1 l 0 -1"
