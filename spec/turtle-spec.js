/* the nose of our turtle can be pointing in one of eight directions */

var createTurtle = require("../src/turtle");
var topo = require("./haus-vom-nikolaus");
describe("The Turtle", function() {
  var turtle, tracer

  beforeEach(function() {
    turtle = createTurtle(topo);
  });

  it("moves forward when reading 'f'", function() {
    expect(turtle("f").d).to.eql("M 0 1 M 0 0");
  });

  it("moves forward, drawing a line when reading 'F'", function() {
    expect(turtle("F").d).to.eql("M 0 1 L 0 0");
  });


  it("turns left when reading '-'", function() {
    expect(turtle("f-F").d).to.eql("M 0 1 M 0 0 L 0 1");
  });

  it("turns right when reading '+'", function() {
    expect(turtle("f+F").d).to.eql("M 0 1 M 0 0 L 1 0");
  });

  it("stores / recalls its state LIFO-style when reading '[' / ']'", function() {
    expect(turtle("[+F[+F]F]-F[-F]F").d).to.eql("M 0 1 L 1 0 L 0 0 M 1 0 L 0 1 M 0 1 L 1 1 L 0 0 M 1 1 L 1 0")
  });

  it("does not generate vertices or edges while moving", function(){
    expect(turtle("fff").vertices).to.eql([]);
  });

  it("generates an edge and vertices when drawing a line", function(){
    expect(turtle("F").edges).to.eql([[0,1]]);
    expect(turtle("F").vertices).to.eql([[0,1], [0,0]]);
  });

  it("reuses vertices when drawing consecutive segments", function(){
    expect(turtle("FF").edges).to.eql([[0,1],[1,2]]);
    expect(turtle("FF").vertices).to.eql([[0,1],[0,0],[0.5,-1]]);
    expect(turtle("F+F").edges).to.eql([[0,1],[1,2]]);
    expect(turtle("F+F").vertices).to.eql([[0,1],[0,0],[1,0]]);
  });

  it("starts with a fresh vertex after moving with f", function(){
    expect(turtle("FfF").edges).to.eql([[0,1],[2,3]]);
    expect(turtle("FfF").vertices).to.eql([[0,1],[0,0],[0.5,-1],[1,0]]);
  });

  describe("when recalling a state with an existing vertex", function(){
    it("reuses that vertex when drawing from that position", function(){
      expect(turtle("F[F]+F").edges).to.eql([[0,1],[1,2],[1,3]]);
      expect(turtle("F[F]+F").vertices).to.eql([[0,1],[0,0],[0.5,-1],[1,0]]);
    });
  });
  describe("when returning to a state with no vertex", function(){
    it("starts with a fresh vertex (it does not check for 'incidental' matches)", function(){
      expect(turtle("[f+F]F").vertices).to.eql([[0,0],[1,0],[0,1],[0,0]]);
      expect(turtle("[f+F]F").edges).to.eql([[0,1],[2,3]]);
    });
  });
  //TODO Probably not required for our use case, but still, for the sake of completeness...
  xdescribe("when returning to a state where there are only outgoing edges", function(){
    it("it will pick up and reuse that vertex (even though it did not exist when the state was pushed!)");
  });  

  describe("using custom steps",function(){
    it("allows defining custom movement commands",function(){
      turtle = createTurtle(topo,{t:{move: function(command, state, topo){
        return topo.move(topo.move(state));
      }}});
      expect(turtle("tF").vertices).to.eql([[0.5,-1],[1,0]]);
      expect(turtle("tF").edges).to.eql([[0,1]]);
    }); 
    it("allows defining custom draw commands", function(){
      turtle = createTurtle(topo,{T:{edge: function(command, vi, vj){
        return [vi,vj, command];
      }}});
      expect(turtle("TF").vertices).to.eql([[0,1],[0,0],[0.5,-1]]);
      expect(turtle("TF").edges).to.eql([[0,1,'T'],[1,2]]);
    });
  });
});
