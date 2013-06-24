expat = require 'node-expat'
events = require 'events'

exports.parse = (readStream, options = {}) ->
  options.stripNamespaces ?= true

  parser = new expat.Parser("UTF-8")
  emitter = new events.EventEmitter()

  readStream.on 'data', (data) -> parser.parse data.toString()
  readStream.on 'end', -> process.nextTick -> emitter.emit 'end'
  readStream.on 'error', (err) -> emitter.emit 'error', err
  readStream.on 'close', -> emitter.emit 'close'




  # parse EVERYTHING inside of them.
  each = (nodeName, eachNode) ->

    eachNodeDelayed = (node) ->
      process.nextTick ->
        eachNode node

    currentNode = null

    parser.on 'error', (err) ->
      emitter.emit 'error', err

    parser.on 'startElement', (name, attrs) ->
      if options.stripNamespaces then name = stripNamespace name
      if name is nodeName or currentNode
        currentNode = {$name: name, $:attrs, $parent: currentNode}

    parser.on 'text', (text) ->
      return if not currentNode?
      currentNode.$text ?= ""
      currentNode.$text += text


    # ok, we only want to collect things if we are under a current node

    parser.on 'endElement', (name) ->
      return if not currentNode?

      if currentNode.$name is nodeName

        if currentNode.$parent
          throw new Error "Top-level node should not have a parent. Possible memory leak"

        eachNodeDelayed currentNode

      parent = currentNode.$parent
      if parent?
        delete currentNode.$parent
        parent.$children ?= []
        parent.$children.push currentNode
        parent[currentNode.$name] = currentNode

      currentNode = parent


  return {
    each: each
    on: (e, cb) -> emitter.on e, cb
    pause: -> readStream.pause()
    resume: -> readStream.resume()
  }

stripNamespace = (name) -> name.replace /^.*:/, ""
