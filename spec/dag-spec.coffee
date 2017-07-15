Dag = require "../src/dag"


describe "In world with the topology of a given directed graph", ->
  {position, move, left, right, initialState} = require "./haus-vom-nikolaus"
  describe "the turtle's initial state", ->
    it "is at the first vertex, facing at the first entry in its adjacenc list", ->
      expect(initialState).to.eql [0,0]
  describe "the turtle's position", ->
    it "is that of the current vertex", ->
      expect(position [0,"does not matter"]).to.eql [0, 1]

  describe "moving forward", ->
    it "looks at the second state component to determine the which edge to traverse", ->
      expect(move([1,1])[0]).to.eql 3
    it "interpretes the adjacent index modulo the length of the source adjacent list", ->
      expect(move([1,6])[0]).to.eql 4
    it "returns the original second component modulo the length of the target's adjacent list", ->
      expect(move([1,6])[1]).to.eql 0

  describe "turning left", ->
    it "stays at the current vertex, but decrements the adjacent pointer", ->
      expect(left([2,1])).to.eql [2,0]
    it "correctly interprete out-of-range pointers", ->
      expect(left([2,31])).to.eql [2,0]
      expect(left([4, -4])).to.eql [4,1]
    it "it will keep the adjacent pointer in a valid range", ->
      expect(left([4,0])).to.eql [4,2]

  describe "turning right", ->
    it "stays at the current vertex, but increments the adjacent pointer", ->
      expect(right([2,0])).to.eql [2,1]
    it "correctly interprete out-of-range pointers", ->
      expect(right([2,31])).to.eql [2,0]
      expect(right([4, -5])).to.eql [4,2]
    it "it will keep the adjacent pointer in a valid range", ->
      expect(right([4,2])).to.eql [4,0]
