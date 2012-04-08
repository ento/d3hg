(function() {
  var d3hg, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.d3hg = d3hg = root.d3hg || {};

  d3hg.graph = function(data) {
    var addLink, addNode, classMap, findNodes, graph, idMap, link, links, maxX, maxY, node, nodes, reset, shapes, _i, _j, _len, _len2, _ref, _ref2;
    idMap = {};
    classMap = {};
    nodes = [];
    links = [];
    shapes = (data ? data.shapes : void 0) || {};
    maxX = 0;
    maxY = 0;
    addNode = function(node) {
      var kls, n, _i, _len, _ref;
      n = Object.create(node);
      n.x = n.x || 0;
      n.y = n.y || 0;
      nodes.push(n);
      if (n.id) idMap[n.id] = node;
      if (node["class"]) {
        _ref = n["class"].split(" ");
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          kls = _ref[_i];
          classMap[kls] || (classMap[kls] = []);
          classMap[kls].push(n);
        }
      }
      maxX = Math.max(maxX, n.x);
      return maxY = Math.max(maxY, n.y);
    };
    findNodes = function(selector) {
      var kind, name, node;
      kind = selector[0];
      name = selector.slice(1);
      if (kind === "#") {
        node = idMap[name];
        if (node) return [node];
      }
      if (kind === ".") return classMap[name] || [];
      return [];
    };
    addLink = function(link) {
      var newLinks;
      newLinks = findNodes(link.source).map(function(s) {
        return findNodes(link.target).map(function(t) {
          return {
            source: s,
            target: t,
            "class": link["class"],
            id: link.id
          };
        });
      });
      return links.push.apply(links, d3.merge(newLinks));
    };
    reset = function() {
      nodes = [];
      idMap = {};
      classMap = {};
      shapes = {};
      maxX = 0;
      return maxY = 0;
    };
    graph = {
      link: function(source, target) {
        if (typeof source === 'string') {
          addLink({
            source: source,
            target: target
          });
        } else if (typeof source === 'object') {
          addLink(source);
        }
        return graph;
      },
      links: function(x) {
        if (!arguments.length) return links;
        links = x;
        return graph;
      },
      node: function(d) {
        addNode(d);
        return graph;
      },
      nodes: function(x) {
        var node, _i, _len;
        if (!arguments.length) return nodes;
        reset();
        for (_i = 0, _len = x.length; _i < _len; _i++) {
          node = x[_i];
          addNode(node);
        }
        return graph;
      },
      draw: function(width, height) {
        return function(selection) {
          var area, diagonal, fragment, opts, selector, shape, stencil, x, y, _i, _j, _len, _len2, _ref, _ref2;
          x = d3.scale.linear().domain([0, maxX + 1]).range([0, width]);
          y = d3.scale.linear().domain([0, maxY + 1]).range([0, height]);
          area = selection.append("g").attr("class", "graph").attr("width", width).attr("height", height);
          area.append("rect").attr("width", width).attr("height", height);
          diagonal = d3.svg.diagonal().projection(function(d) {
            return [x(d.x), y(d.y)];
          });
          area.selectAll("path").data(graph.links()).enter().append("path").attr("id", function(d) {
            return d.id;
          }).attr("class", function(d) {
            return (d["class"] || "") + " link";
          }).attr("d", diagonal).attr("fill", "none");
          area.selectAll("g.node").data(graph.nodes()).enter().append("g").attr("id", function(d) {
            return d.id;
          }).attr("class", function(d) {
            return (d["class"] || "") + " node";
          }).attr("transform", function(d) {
            return "translate(" + (x(d.x)) + "," + (y(d.y)) + ")";
          });
          for (_i = 0, _len = shapes.length; _i < _len; _i++) {
            _ref = shapes[_i], selector = _ref.selector, shape = _ref.shape, opts = _ref.opts;
            stencil = d3hg.stencils;
            _ref2 = shape.split('.');
            for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
              fragment = _ref2[_j];
              stencil = stencil[fragment];
            }
            area.selectAll(selector).call(stencil, opts);
          }
          return area;
        };
      }
    };
    if (data) {
      _ref = data.nodes || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        addNode(node);
      }
      _ref2 = data.links || [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        link = _ref2[_j];
        addLink(link);
      }
    }
    return graph;
  };

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
