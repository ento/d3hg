root = exports ? this
root.d3hg = d3hg = root.d3hg || {}

d3hg.graph = (data) ->
  idMap = {}
  classMap = {}
  nodes = []
  links = []
  shapes = (data.shapes if data) || {}
  maxX = 0
  maxY = 0

  addNode = (node) ->
    n = Object.create(node)
    n.x = n.x || 0
    n.y = n.y || 0
    nodes.push(n)
    if n.id
      idMap[n.id] = node
    if node.class
      for kls in n.class.split(" ")
        classMap[kls] ||= []
        classMap[kls].push(n)
    maxX = Math.max(maxX, n.x)
    maxY = Math.max(maxY, n.y)

  findNodes = (selector) ->
    kind = selector[0]
    name = selector[1..-1]
    if kind == "#"
      node = idMap[name]
      if node
        return [node]
    if kind == "."
      return classMap[name] || []
    return []

  addLink = (link) ->
    newLinks = findNodes(link.source).map (s) ->
      findNodes(link.target).map (t) ->
        {source: s, target: t, class: link.class, id: link.id}
    links.push.apply(links, d3.merge(newLinks))

  reset = ->
    nodes = []
    idMap = {}
    classMap = {}
    shapes = {}
    maxX = 0
    maxY = 0

  graph =
    link: (source, target) ->
      if typeof(source) == 'string'
        addLink
          source: source
          target: target
      else if typeof(source) == 'object'
        addLink source
      graph
    links: (x) ->
      if !arguments.length
        return links
      links = x
      graph
    node: (d) ->
      addNode(d)
      graph
    nodes: (x) ->
      if !arguments.length
        return nodes
      reset()
      for node in x
        addNode(node)
      graph
    draw: (width, height) ->
      (selection) ->
        x = d3.scale.linear().domain([0, maxX + 1]).range([0, width])
        y = d3.scale.linear().domain([0, maxY + 1]).range([0, height])

        area = selection.append("g")
          .attr("class", "graph")
          .attr("width", width)
          .attr("height", height)
        area.append("rect")
          .attr("width", width)
          .attr("height", height)

        diagonal = d3.svg.diagonal()
          .projection((d) -> [x(d.x), y(d.y)])

        area.selectAll("path")
          .data(graph.links())
          .enter().append("path")
          .attr("id", (d) -> d.id)
          .attr("class", (d) -> (d.class || "") + " link")
          .attr("d", diagonal)
          .attr("fill", "none")

        area.selectAll("g.node")
          .data(graph.nodes())
          .enter().append("g")
          .attr("id", (d) -> d.id)
          .attr("class", (d) -> (d.class || "") + " node")
          .attr("transform", (d) -> "translate(#{x(d.x)},#{y(d.y)})")

        for {selector, shape, opts} in shapes
          stencil = d3hg.stencils
          for fragment in shape.split('.')
            stencil = stencil[fragment]
          area.selectAll(selector).call(stencil, opts)
        area

  if data
    for node in data.nodes || []
      addNode node

    for link in data.links || []
      addLink link

  graph
