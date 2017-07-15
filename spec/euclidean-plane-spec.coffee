
describe "In the Euclidean Plane", ->
  Movement = require "../src/euclidean-plane"
  {PI,sin,cos} = Math
  {move,left,right,initialState,position} = Movement 
    turnAngle:PI/4 # 45°
    stepWidth: 1
    handedness: "left"

  [N,NE,E,SE,S,SW,W,NW] = (i*PI/4 for i in [0...8])

  describe "the turtle's initial state",->
    it "is at cell 0,0 facing 'north'", ->
      expect(initialState).to.eql([0,0,N])
      expect(move initialState).to.eql([0,-1,N])

  describe "the turtle's position", ->
    it "can be obtained by calling the `position`-function", ->
      p = position([42,23,1.23456])
      expect(p).to.be.an.instanceOf Array
      expect(p[0]).to.eql 42
      expect(p[1]).to.eql 23

  describe "moving forward", ->
    it "changes the position by moving a configured distance into the current direction
        but without changing the direction", ->
      expect(move [0,0,0]).to.almost.eql [0,-1,N]
      expect(move [0,0,E]).to.almost.eql [1,0,E]
      expect(move [0,0,SW]).to.almost.eql [sin(SW),-cos(SW),SW]
      expect(move [0,0,S]).to.almost.eql [0,1,S]
  describe "turning left", ->
    it "changes the direction counter clockwise, without changing the position", ->
      expect(left([0, 0, N])).to.eql([0, 0, NW])
      expect(left([0, 0, NW])).to.eql([0, 0, W])
      expect(left([0, 0, W])).to.eql([0, 0, SW])
      expect(left([0, 0, SW])).to.eql([0, 0, S])
      expect(left([0, 0, S])).to.eql([0, 0, SE])
      expect(left([0, 0, SE])).to.eql([0, 0, E])
      expect(left([0, 0, E])).to.eql([0, 0, NE])
      expect(left([0, 0, NE])).to.eql([0, 0, N])
    
  
  describe "turning right", ->
    it "changes the direction clockwise, without changing the position", ->
      expect(right([0, 0, N])).to.eql([0, 0, NE])
      expect(right([0, 0, NW])).to.eql([0, 0, N])
      expect(right([0, 0, W])).to.eql([0, 0, NW])
      expect(right([0, 0, SW])).to.eql([0, 0, W])
      expect(right([0, 0, S])).to.eql([0, 0, SW])
      expect(right([0, 0, SE])).to.eql([0, 0, S])
      expect(right([0, 0, E])).to.eql([0, 0, SE])
      expect(right([0, 0, NE])).to.eql([0, 0, E])
    
  
