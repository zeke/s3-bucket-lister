
xml-object-stream
=================

Streaming parsers are hard to work with, but sometimes you need to parse a really big file. This module gives you the best of both worlds. You give it a specific node to look for, and it will return each of those nodes as an object, one at a time, without loading the whole document into memory at once.

Uses node-expat for fast(est) xml processing.

Installation 
------------

    npm install xml-object-stream

Parsing a ReadStream
--------------------

Let's say we have a file, hugePersonDirectory.xml, that looks something like this:

    <root>
      <people>
        <person>...</person>
        <person>...</person>
        <person>...</person>
        <person>...</person>
        <person>...</person>
      </people>
    <root>

You want to do something with each person object, but you can't load them all into memory at once. 

    xml = require 'xml-object.stream'
    fs = require 'fs'

    readStream = fs.createReadStream 'hugePersonDirectory.xml'
    parser = xml.parse readStream

    parser.each 'person', (person) ->
      # do something with the person!

The parser emits some streaming events
    
    parser.on 'end', ->
    parser.on 'error', (err) ->
    parser.on 'close', ->

You can pause and resume it if the xml parser gets too far ahead of your processing

    parser.pause()

    # then when you catch back up
    parser.resume()

Since the parser takes any read stream, you can use it to parse urls without saving them to disk. 

Node Object Format
-----------------

Nodes are converted to objects. For the following xml:

    <person id="asdf123">
      <firstName>Bob</firstName>
      <lastName>Wilson</lastName>
      <employee id="asdf123"/>
      <note author="Joe">Bob is a poor worker</note>
      <note author="Jim">Bob spends all his time parsing xml</note>
    </person>

You can access attributes with the `$` property

    person.$.id == "asdf123"

You can access the *last* child of a given name by its name. Text is accessed with $text
  
    person.firstName.$text == "Bob"

Node names are available under the `$name` property

    person.$name == "person"

Every child node is put into the `$children` array

    notes = person.$children.filter (child) ->
      return (child.$name is "note")

    notes[0].$.author == "Joe"

API Reference
-------------

    exports.parse = (nodeReadStream, [options]) ->
      # returns a Parser

    class Parser

      # calls cb each time it finds a node with that name
      each: (nodeName, cb) ->

      # bind to 'end', 'error', and 'close'
      on: (eventName, cb) ->

      # pause or resume the read stream to let you processor catch up
      pause: ->
      resume: ->
      

Options
----------

    {
      # removes all namespace information from the node names
      stripNamespaces: false
    }

    
