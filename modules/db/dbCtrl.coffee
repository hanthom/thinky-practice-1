q = require 'q'
models = require "#{__dirname}/models"
{r} = require "#{__dirname}/dbConfig"
module.exports = (options)->
  plugin = 'db'
  patterns =
    create:
      cmd: 'create'
      # model: string
    read:
      cmd: 'read'
      # model: string
    update:
      cmd: 'update'
      # model: string
    remove:
      cmd: 'remove'
      # model: string
    watch:
      cmd: 'watch'
      # model: string

  _act = (actionOpts, host)->
    dfd = q.defer()
    client = require('seneca')()
      .client
        host: host
        port: 10101
    client.ready ->
      client.act actionOpts, (err, res)->
        client.close ->
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
      base = "#{base}-- #{arg}: #{val}\n"
    base

  _dbError = (type, err, done, args)->
    message = _buildMessage type, args
    logOpts =
      role: 'util'
      cmd: 'handleErr'
      message: message
      service: plugin
      err: err
    _act logOpts, 'util'
    done null, err: message

  ##### crudCreate #####
  # Creates an item on the DB
  # @params: model -> string
  # @params: insert -> object
  # @resolves: object
  create = (args, done) ->
    {model, insert} = args
    if !model or !insert
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        type: 'missing_args'
        given: [
          {name: 'model'
          value: model},
          {name: 'insert'
          value: insert}
        ]
        name: 'create'
        service: 'db'
      _act errOpts, 'util'
      .then (builtErr)->
        done null, err: builtErr
    else
      new models[model] insert
        .save()
        .then (res) ->
          done null, data: res
        .catch (err)->
          _dbError 'create', err, done,
            model: model
            insert: insert



  ##### crudRead #####
  # Gets the requested info from the DB
  # @params: query.build -> fn that expects thinky model and returns a query
  # @resolves: Object or Array based on query
  read = (args, done) ->
    {model, query} = args
    model = models[model]
    query.build model
      .run()
      .then (res) ->
        done null, data: res
      .catch (err)->
        _dbError 'read', err, done,
          model: model
          query: query


  ##### crudUpdate #####
  # Updates the queried doc(s) with the changes
  # @params: query.build -> fn that expects thinky model and returns a query
  # @resolves: Updated object or array of updated objects
  update = (args, done) ->
    {model, query} = args
    query.build models[model]
      .update changes
      .run()
      .then (res) ->
        done null, data: res
      .catch (err)->
        _dbError 'update', err, done,
          model: model
          query: query

  ##### crudDelete #####
  # Deletes the specifed object
  # @params: modelObj -> Thinky Model
  # @params: id -> string
  # @resolves: Object
  remove = (args, done) ->
    {model, id, query} = args
    _query = models[model]
    if id
      _query = query.get id
    else
      _query = query.build query
    _query
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
