root = exports ? this
root.d3hg = d3hg = root.d3hg || {}

d3hg.stencils =
  attr: (selection, opts) ->
    selection.attr(key, val) for key, val of opts
  dot: (selection, opts) ->
    selection
      .append("circle")
      .attr("r", opts.r || 10)
      .attr("stroke-width", 3)
      .attr("stroke", "#fff")
      .attr("fill", opts.fill || "#2d578b")
  text: (selection, opts) ->
    text = selection
      .append("text")
      .attr("x", x = opts.x || 0)
      .attr("y", y = opts.y || 0)
      .attr("text-anchor", opts["text-anchor"] || "middle")
      .attr("width", opts.width)
      .attr("height", opts.height)
    if opts.rotation
      text.attr("transform", "rotate(#{opts.rotation} #{x} #{y})")
    for line, i in opts.text.split('\n')
      text
        .append("tspan")
        .attr('x', 0)
        .attr('dy', i * 1.1 + 'em')
        .text(line)
