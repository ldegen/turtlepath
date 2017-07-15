
/* the nose of our turtle can be pointing in one of eight directions */
var N = 0,
  NE = 1,
  E = 2,
  SE = 3,
  S = 4,
  SW = 5,
  W = 6,
  NW = 7;

/* the initial state we will assume for testing */
var initialState = [0, 0, N];

var move = function(state) {

  var x=state[0],y=state[1],d=state[2];
  switch(d){
  case N: return [x,y-1,d];
  case NE: return [x+1,y-1,d];
  case E: return [x+1,y,d];
  case SE: return [x+1,y+1,d];
  case S: return [x,y+1,d];
  case SW: return [x-1,y+1,d];
  case W: return [x-1,y,d];
  case NW: return [x-1,y-1,d];
  default: throw new Error("bad direction: "+d);
  }
};
var left = function(state) {
  var x=state[0],y=state[1],d=state[2];
  return [x,y,(8+d-1) % 8];
};
var right = function(state) {
  var x=state[0],y=state[1],d=state[2];
  return [x,y,(8+d+1) % 8];
};
var position = function(state) {
  return state.slice(0,2);
};

module.exports = {
  initialState: initialState,
  move:move,
  left:left,
  right:right,
  position:position
};
