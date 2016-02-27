{Todo} = require '../models/models'
q = require 'q'

{r} = require "#{__dirname}/../config/dbConfig"

handleErr = (action, message, promise)->
  # Creates a log message and rejects promise with log
  # @params: action -> string
  # @params: message -> string
  # @params: promise -> q.defer object
  log = "ERROR #{action} >>>> #{message}"
  console.log log
  promise.reject log

module.exports =
  addTodo: (todo)->
    # Adds a todo to the database
    # @params: object
    # @returns: promise
    # @resolves: object
    dfd = q.defer()
    new Todo todo
      .save()
      .then (doc)->
        console.log 'TODO SAVED >>>>', doc
        dfd.resolve doc
      .catch (e)->
        handleErr 'SAVING TODO', e.message, dfd
    dfd.promise

  getOneTodo: (id)->
    # Retrieves one todo from the database
    # @params: string
    # @returns: promise
    # @resolves: object
    dfd = q.defer()
    Todo
      .get id
      .run()
      .then (todo)->
        console.log 'TODO >>>>', todo
        dfd.resolve todo
      .catch (e)->
        handleErr 'GETTING TODO', e.message, dfd
    dfd.promise

  getAllTodos: (status)->
    dfd = q.defer()
    query = Todo
      .orderBy index: r.desc 'createdAt'
    if status != 'all'
      query = query.filter status: status
    query
      .run()
      .then (todos)->
        console.log 'TODOS >>>>', todos
        dfd.resolve todos
      .catch (e)->
        handleErr 'GETTING TODOS', e.message, dfd
    dfd.promise

  editTodo: (id, changes)->
    dfd = q.defer()
    Todo
      .get id
      .update changes
      .run()
      .then (result)->
        dfd.resolve result
      .catch (e)->
        handleErr 'UPDATING TODO', e.message, dfd
    dfd.promise

  deleteTodo: (id)->
    dfd = q.defer()
    Todo
      .get id
      .delete()
      .run()
      .then (result)->
        console.log "DELETED TODO #{id}"
        dfd.resolve()
      .catch (e)->
        handleErr 'DELETING TODO', e.message, dfd
    dfd.promise
