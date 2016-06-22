q = require 'q'
models = require "#{__dirname}/models"
{r} = require "#{__dirname}/dbConfig"
module.exports = (options)->
  plugin = 'db'
  patterns =
    create:
      cmd: 'create'
      # model: string
      # insert: object
    read:
      cmd: 'read'
      # model: string
      # query:
      #   primary_key: string
      #   filters: object
      #   without: array
      #   pluck: array
      #   joins: Unsupported RN
    update:
      cmd: 'update'
      # model: string
      # query:
      #   primary_key: string
      #   filters: object
    remove:
      cmd: 'remove'
      # model: string
      # query:
      #   primary_key: string
      #   filters: object
    watch:
      cmd: 'watch'
      # model: string

  _clients = {}
  _act = (actionOpts, host)->
    dfd = q.defer()
    client = null
    if !_clients[host]
      client = require('seneca')()
        .client
          host: host
          port: 10101
      _clients[host] = client
    else
      client = _clients[host]
    client.ready ->
      client.act actionOpts, (err, res)->
        if err
          dfd.reject err
        else
          if res.err
            dfd.reject res.err
          else
            dfd.resolve res.data
    dfd.promise

  _buildMessage = (type, args)->
    base = "Error during #{type} on db\n
    --- Arguements ---\n"
    for arg, val of args
      base = "#{base}-- #{arg}: #{JSON.stringify val}\n"
    base

  _buildQuery = (query, modelName)->
    {primary_key, filters, joins, without, pluck} = query
    model = models[modelName]
    base = model
    if primary_key
      base = base.get primary_key
    else if filters
      base = base.filter filters
    if without
      base = base.without without
    if pluck
      base = base.pluck pluck
    if joins
      console.log 'NO LOGIC FOR JOINS YET'
    base

  _dbError = (type, err, done, args)->
    message = _buildMessage type, args
    logOpts =
      role: 'util'
      cmd: 'handleErr'
      type: 'general'
      message: message
      service: plugin
      err: err
    _act logOpts, 'util'
    done null, err: message

  read = (args, done)->
    {model, query} = args
    if !model or !query
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        type: 'missing_args'
        given: [
          {name: 'model', value: model},
          {name: 'query', value: query}
        ]
        name: 'read'
        service: 'db'
      _act errOpts, 'util'
      .then (builtErr)->
        done null, err: builtErr
    else
      _buildQuery query, model
        .run()
        .then (doc)->
          if Array.isArray(doc) and doc.length is 0
            err =
              status: 404
              message: 'No documents returned'
            _dbError 'read', err, done,
              model: model
              query: query
          else
            done null, data: doc
        .catch (err)->
          _dbError 'read', err, done,
            model: model
            query: query


  create = (args, done) ->
    {model, insert} = args
    if !model or !insert
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        type: 'missing_args'
        given: [
          {name: 'model', value: model},
          {name: 'insert', value: JSON.stringify insert}
        ]
        name: 'create'
        service: 'db'
      _act errOpts, 'util'
      .then (builtErr)->
        done null, err: builtErr
    else
      Model = models[model]
      new Model insert
        .save()
        .then (res) ->
          done null, data: res
        .catch (err)->
          _dbError 'create', err, done,
            model: model
            insert: insert

  update = (args, done) ->
    {model, query, changes} = args
    {model, query} = args
    if !model or !query
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        type: 'missing_args'
        given: [
          {name: 'model', value: model},
          {name: 'query', value: query}
        ]
        name: 'update'
        service: 'db'
      _act errOpts, 'util'
      .then (builtErr)->
        done null, err: builtErr
    else
      _buildQuery query, model
        .update changes
        .run()
        .then (res) ->
          done null, data: res
        .catch (err)->
          _dbError 'update', err, done,
            model: model
            build: build

  remove = (args, done) ->
    {model, query} = args
    if !model or !query
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        type: 'missing_args'
        given: [
          {name: 'model', value: model},
          {name: 'query', value: query}
        ]
        name: 'remove'
        service: 'db'
      _act errOpts, 'util'
      .then (builtErr)->
        done null, err: builtErr
    else
      _buildQuery model, query
        .delete()
        .run()
        .then (res) ->
          done null, data: res
        .catch (err)->
          _dbError 'remove', err, done,
            model: model
            query: query

  ##### watchModelFeed #####
  # Watches a model table for changes and handles with cb if provided
  # @params: model -> Thinky model
  # @params: cb -> function
  watchModelFeed = (args, done)->
    {model, cb} = args
    models[model]
      .changes()
      .then (feed)->
        if !cb
          feed.each (e, doc)->
            if e
              _dbError "#{model} feed watch", e, done,
                model: model
                cb: cb
            else
              message = "Changes to #{model}\n
              #{JSON.stringify doc}"
              logOpts =
                role: 'util'
                cmd: 'log'
                type: 'general'
                message: message
              _act logOpts, 'util'
        else
          cb feed
    done null, message: "Change feed for #{model} started"

  for pattern, val of patterns
    patterns[pattern].role = plugin

  @add patterns.create, create
  @add patterns.read, read
  @add patterns.update, update
  @add patterns.remove, remove
  @add patterns.watch, watchModelFeed
