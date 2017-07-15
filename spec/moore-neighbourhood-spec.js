/* the nose of our turtle can be pointing in one of eight directions */
var N = 0,
  NE = 1,
  E = 2,
  SE = 3,
  S = 4,
  SW = 5,
  W = 6,
  NW = 7;

var movement = require("../src/moore-neighbourhood");
var position = movement.position,
  move = movement.move,
  left = movement.left,
  right = movement.right;
  initialState = movement.initialState;
describe("In a Moore-Neighbourhood", function() {
  describe("the turtle's initial state", function() {
    it("is at cell 0,0, facing north", function() {
      expect(initialState).to.eql([0,0,N]);
    });
  });
  describe("the turtle's position", function() {
    it("can be obtained by calling the `position`-function", function() {
      debugger;
      var p = position([42, 23, SE]);
      expect(p).to.be.an.instanceOf(Array);
      expect(p[0]).to.eql(42);
      expect(p[1]).to.eql(23);
    });
  });

  describe("moving forward", function() {
    it("changes the position to a neighbouring cell, without changing the direction", function() {
      expect(move([0, 0, N])).to.eql([0, -1, N]);
      expect(move([0, 0, NE])).to.eql([1, -1, NE]);
      expect(move([0, 0, E])).to.eql([1, 0, E]);
      expect(move(move([0, 0, SE]))).to.eql([2, 2, SE]);
      expect(move([0, 0, S])).to.eql([0, 1, S]);
      expect(move([0, 0, SW])).to.eql([-1, 1, SW]);
      expect(move([0, 0, W])).to.eql([-1, 0, W]);
      expect(move([0, 0, NW])).to.eql([-1, -1, NW]);
    });
  });
  describe("turning left", function() {
    it("changes the direction counter clockwise, without changing the position", function() {
      expect(left([0, 0, N])).to.eql([0, 0, NW]);
      expect(left([0, 0, NW])).to.eql([0, 0, W]);
      expect(left([0, 0, W])).to.eql([0, 0, SW]);
      expect(left([0, 0, SW])).to.eql([0, 0, S]);
      expect(left([0, 0, S])).to.eql([0, 0, SE]);
      expect(left([0, 0, SE])).to.eql([0, 0, E]);
      expect(left([0, 0, E])).to.eql([0, 0, NE]);
      expect(left([0, 0, NE])).to.eql([0, 0, N]);
    });
  });
  describe("turning right", function() {
    it("changes the direction clockwise, without changing the position", function() {
      expect(right([0, 0, N])).to.eql([0, 0, NE]);
      expect(right([0, 0, NW])).to.eql([0, 0, N]);
      expect(right([0, 0, W])).to.eql([0, 0, NW]);
      expect(right([0, 0, SW])).to.eql([0, 0, W]);
      expect(right([0, 0, S])).to.eql([0, 0, SW]);
      expect(right([0, 0, SE])).to.eql([0, 0, S]);
      expect(right([0, 0, E])).to.eql([0, 0, SE]);
      expect(right([0, 0, NE])).to.eql([0, 0, E]);
    });
  });
});
