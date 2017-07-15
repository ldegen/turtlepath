module.exports = function() {
  var tracer = function(name) {
    return function(s) {
      console.log("s",s);
      console.log("tracer.values", tracer.values);
      console.log("tracer.trace.length", tracer.trace.length);
      var v = tracer.values && tracer.values[tracer.trace.length] || s + 1;
      tracer.trace.push(s + ":" + name);
      return v;
    };
  };
  tracer.trace = [];
  return tracer;
};
