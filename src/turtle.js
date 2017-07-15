module.exports = function(topo, customSteps={}) {
  var defaultMove = function(command, state, topo) {
    return topo.move(state);
  };

  var defaultEdge = function(command, vi1, vi2, vertices) {
    return [vi1, vi2];
  };

  return function(commands0) {
    var commands = Array.prototype.slice.call(commands0);
    var state = topo.initialState;
    var d = "M " + topo.position(state).join(" ");
    var stack = [];
    var vertices = [];
    var vi = null;
    var edges = [];
    var drawTemplate = function(command, move=defaultMove, mkEdge=defaultEdge) {
      if (vi === null) {
        vi = vertices.length;
      }
      if (!vertices[vi]) {
        vertices[vi] = topo.position(state);
      }
      var vi1 = vi;
      var vi2 = vi = vertices.length;
      state = move(command, state, topo);
      vertices[vi] = topo.position(state);
      var edge = mkEdge(command, vi1, vi2, vertices);
      edges.push(edge);
      d += " L " + topo.position(state).join(" ");
    };
    var moveTemplate = function(command, move=defaultMove) {
      vi = null;
      state = move(command, state, topo);
      d += " M " + topo.position(state).join(" ");
    };



    commands.forEach(function(command) {
      var customStep = customSteps[command];
      if (customStep) {
        if (customStep.edge) {
          drawTemplate(command, customStep.move, customStep.edge);
        } else if (customStep.move) {
          moveTemplate(command, customStep.move);
        }
      } else {
        switch (command) {
          case '[':
            stack.push([state, vi]);
            break;
          case ']':
            [state, vi] = stack.pop();
            d += " M " + topo.position(state).join(" ");
            break;
          case 'F':
            drawTemplate(command, defaultMove, defaultEdge);
            break;
          case 'f':
            moveTemplate(command, defaultMove);
            break;
          case '-':
            state = topo.left(state);
            break;
          case '+':
            state = topo.right(state);
            break;
          default:
            //nothing
        }
      }
    });
    return {
      d,
      vertices,
      edges
    };
  };
};
