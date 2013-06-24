assert = require 'assert'
{Stream} = require 'stream'
{parse} = require './index'



streamData = (xml) ->
  stream = new Stream()
  process.nextTick ->
    stream.emit 'data', xml
    stream.emit 'end'
  return stream

describe "xml streamer thing", ->

  it "should parse", (done) ->
    foundBook = false

    xml = """
    <root>
      <book asdf="asdf">
        <author name="john"></author>
        <author><name>will</name></author>
        <title>Title</title>
        <description>stuff</description>
      </book>
    </root>
    """

    stream = streamData xml

    parser = parse stream
    parser.each 'book', (book) ->
      foundBook = true
      assert.ok book
      assert.equal book.$.asdf, "asdf"
      assert.equal book.title.$text, "Title"
      assert.equal book.description.$text, "stuff"

      authors = book.$children.filter (node) -> node.$name is "author"
      assert.equal authors.length, 2
      assert.equal authors[0].$.name, "john"
      assert.equal authors[1].name.$text, "will"

    parser.on 'end', ->
      assert.ok foundBook
      done()


  it 'should find all the nodes', (done) ->
    found = []

    xml = """
    <root>
      <items>
        <item name="1"/>
        <item name="2"/>
        <item name="3"/>
        <item name="4"/>
        <item name="5"/>
        <item name="6"/>
        <item name="7"/>
        <item name="8"/>
      </items>
    </root>
    """

    stream = streamData xml

    parser = parse stream
    parser.each 'item', (item) ->
      found.push item

    parser.on 'end', ->
      assert.equal found.length, 8
      done()


  describe 'namespaces', ->
    it 'should strip namespaces by default', (done) ->
      stream = streamData """
        <root>
          <me:item>one</me:item>
        </root>
      """

      found = []
      parser = parse stream
      parser.each 'item', (item) ->
        found.push item
        assert.equal item.$text, "one"
      parser.on 'end', ->
        assert.equal found.length, 1
        done()

    it 'should preserve them if you turn it off', (done) ->
      stream = streamData """
        <root>
          <me:item>one</me:item>
        </root>
      """

      found = []
      parser = parse stream, {stripNamespaces: false}
      parser.each 'me:item', (item) ->
        found.push item
        assert.equal item.$text, "one"
      parser.on 'end', ->
        assert.equal found.length, 1
        done()

