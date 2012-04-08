(function() {
  var d3hg, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.d3hg = d3hg = root.d3hg || {};

  d3hg.stencils = {
    attr: function(selection, opts) {
      var key, val, _results;
      _results = [];
      for (key in opts) {
        val = opts[key];
        _results.push(selection.attr(key, val));
      }
      return _results;
    },
    dot: function(selection, opts) {
      return selection.append("circle").attr("r", opts.r || 10).attr("stroke-width", 3).attr("stroke", "#fff").attr("fill", opts.fill || "#2d578b");
    },
    text: function(selection, opts) {
      var i, line, text, x, y, _len, _ref, _results;
      text = selection.append("text").attr("x", x = opts.x || 0).attr("y", y = opts.y || 0).attr("text-anchor", opts["text-anchor"] || "middle").attr("width", opts.width).attr("height", opts.height);
      if (opts.rotation) {
        text.attr("transform", "rotate(" + opts.rotation + " " + x + " " + y + ")");
      }
      _ref = opts.text.split('\n');
      _results = [];
      for (i = 0, _len = _ref.length; i < _len; i++) {
        line = _ref[i];
        _results.push(text.append("tspan").attr('x', 0).attr('dy', i * 1.1 + 'em').text(line));
      }
      return _results;
    }
  };

}).call(this);
