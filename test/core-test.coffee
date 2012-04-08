{d3hg, document, window} = require './env'
should = require 'should'

describe 'd3hg.graph', ->
  g = null
  earl = null
  blue = null
  kona = null

  beforeEach ->
    g = d3hg.graph()
    earl =
      id: 'earl'
      class: 'tea orange'
      x: 1
      y: 2
    blue =
      id: 'blue'
      class: 'coffee blue'
      x: 3
      y: 4
    kona =
      id: 'kona'
      class: 'coffee orange'
      x: 9
      y: 9
    d3.select('body').html('')

  describe '#()', ->
    it "should create a new graph object with no args", ->
      should.exist g
      g.nodes().should.have.lengthOf 0
      g.links().should.have.lengthOf 0

  describe '#()', ->
    it "should create a new graph object with initial nodes and links", ->
      # TODO: add test

  describe '#node() and #nodes()', ->
    it "should store node return it", ->
      g.node earl

      earl.x = 3
      g.node earl

      g.nodes().should.have.lengthOf 2
      first = g.nodes()[0]
      first.should.have.property('id', 'earl')
      first.should.have.property('class', 'tea orange')
      first.should.have.property('x', 1)
      first.should.have.property('y', 2)

      second = g.nodes()[1]
      second.should.have.property('id', 'earl')
      second.should.have.property('class', 'tea orange')
      second.should.have.property('x', 3)
      second.should.have.property('y', 2)

  describe '#nodes(x)', ->
    it "should replace nodes", ->
      g.node blue

      nodes = [earl, blue]
      g.nodes(nodes)

      g.nodes().should.have.lengthOf 2
      first = g.nodes()[0]
      first.should.have.property('id', 'earl')
      first.should.have.property('class', 'tea orange')
      first.should.have.property('x', 1)
      first.should.have.property('y', 2)

  describe '#link()', ->
    it "should link from id to id", ->
      g.nodes [earl, blue]
      g.link '#earl', '#blue'

      g.links().should.have.lengthOf 1
      link = g.links()[0]
      link.source.id.should.equal(earl.id)
      link.target.id.should.equal(blue.id)

    it "should link from id to class", ->
      g.nodes [earl, blue, kona]
      g.link '#earl', '.coffee'

      g.links().should.have.lengthOf 2
      g.links()[0].source.id.should.equal(earl.id)
      g.links()[0].target.id.should.equal(blue.id)
      g.links()[1].source.id.should.equal(earl.id)
      g.links()[1].target.id.should.equal(kona.id)

    it "should link from class to id", ->
      g.nodes [earl, blue, kona]
      g.link '.coffee', '#earl'

      g.links().should.have.lengthOf 2
      g.links()[0].source.id.should.equal(blue.id)
      g.links()[0].target.id.should.equal(earl.id)
      g.links()[1].source.id.should.equal(kona.id)
      g.links()[1].target.id.should.equal(earl.id)

    it "should link from class to class", ->
      g.nodes [earl, blue, kona]
      g.link '.coffee', '.orange'

      g.links().should.have.lengthOf 4
      g.links()[0].source.id.should.equal(blue.id)
      g.links()[0].target.id.should.equal(earl.id)
      g.links()[1].source.id.should.equal(blue.id)
      g.links()[1].target.id.should.equal(kona.id)
      g.links()[2].source.id.should.equal(kona.id)
      g.links()[2].target.id.should.equal(earl.id)
      g.links()[3].source.id.should.equal(kona.id)
      g.links()[3].target.id.should.equal(kona.id)

  describe '#link()', ->
    it "should accept link object", ->
      g.nodes [earl, blue]
      g.link {source: '#earl', target: '#blue', id: 'earl-blue', class: 'thin'}

      g.links().should.have.lengthOf 1
      link = g.links()[0]
      link.source.id.should.equal(earl.id)
      link.target.id.should.equal(blue.id)
      link.id.should.equal('earl-blue')
      link.class.should.equal('thin')

  describe '#draw()', ->
    it "should append a group which represent the graph", ->
      body = d3.select('body')
      body.call(g.draw(100, 200))
      body.select('g.graph').should.have.lengthOf(1)
      body.select('g.graph').attr('width').should.equal('100')
      body.select('g.graph').attr('height').should.equal('200')

    it "should append groups which represent the nodes", ->
      g.nodes [earl, blue]
      body = d3.select('body')
      body.call(g.draw(100, 200))
      body.select('g#earl.node').should.have.lengthOf(1)
      body.select('g#earl.node').attr('class').should.equal('tea orange node')
      body.select('g#earl.node').attr('transform').should.equal('translate(25,80)')

      body.select('g#blue.node').should.have.lengthOf(1)
      body.select('g#blue.node').attr('class').should.equal('coffee blue node')
      body.select('g#blue.node').attr('transform').should.equal('translate(75,160)')

    it "should append paths which represent the links", ->
      g.nodes [earl, blue]
      g.link
        source: '#earl'
        target: '#blue'
        id: 'earl-blue'
        class: 'thin'

      body = d3.select('body')
      body.call(g.draw(100, 200))
      body.select('path#earl-blue').should.have.lengthOf(1)
      body.select('path#earl-blue').attr('class').should.equal('thin link')
