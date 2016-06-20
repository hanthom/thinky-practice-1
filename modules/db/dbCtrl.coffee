q = require 'q'
models = require "#{__dirname}/models"
module.exports = (options)->
  plugin = 'db'
  patterns =
    create:
      cmd: 'create'
    read:
      cmd: 'read'
    update:
      cmd: 'update'
    remove:
      cmd: 'remove'
    watch:
      cmd: 'watch'
  for pattern, val of patterns
    patterns[pattern].role = plugin
  @add patterns.create, create
  @add patterns.read, read
  @add pattters.update, update
  @add patterns.remove, remove
  @add patterns.watch, watchModelFeed

  _act = (actionOpts)=>
    dfd = q.defer()
    @act actionOpts, (err, res)->
      if err
        dfd.reject err
      else
        dfd.resolve res
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
    _act logOpts
    done message: message

  ##### crudCreate #####
  # Creates an item on the DB
  # @params: model -> string
  # @params: insert -> object
  # @resolves: object
  create = (args, done) ->
    {model, insert} = args
    new models[model] insert
      .save()
      .then (res) ->
        done null, res
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
        done null, res
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
    query
      .update changes
      .run()
      .then (res) ->
        done null, res
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
    {model, id} = args
    models[model]
      .get id
      .delete()
      .run()
      .then (res) ->
        done null, res
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
              _act logOpts
        else
          cb feed
    done()
