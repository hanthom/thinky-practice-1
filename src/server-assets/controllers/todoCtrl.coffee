q = require 'q'
crudHelper = require "#{__dirname}/../helpers/crudHelper"

{Todo} = require '../models/models'
{db} = require "#{__dirname}/../config/dbConfig"
{r} = db
{crudCreate, crudRead, crudUpdate, crudDelete} = crudHelper

module.exports =

  ##### addTodo #####
  # Adds a todo to the database
  # @params: object
  # @returns: promise
  # @resolves: object
  addTodo: (todo)->
    crudCreate Todo, todo
    # dfd = q.defer()
    # new Todo todo
    #   .save()
    #   .then (doc)->
    #     console.log 'TODO SAVED >>>>', doc
    #     dfd.resolve doc
    #   .catch (e)->
    #     handleErr 'SAVING TODO', e.message, dfd
    # dfd.promise

  ##### getOneTodo #####
  # Retrieves one todo from the database
  # @params: string
  # @returns: promise
  # @resolves: object

  getOneTodo: (id)->
    crudRead Todo.get id
    # dfd = q.defer()
    # Todo
    #   .get id
    #   .run()
    #   .then (todo)->
    #     console.log 'TODO >>>>', todo
    #     dfd.resolve todo
    #   .catch (e)->
    #     handleErr 'GETTING TODO', e.message, dfd
    # dfd.promise

  ##### getAllTodos #####
  # Gets all todos matching the given status
  # Returns todos ordered with newest first
  # @params: string
  # @returns: promise
  # @resolves: array

  getTodos: (status)->
    query = Todo
      .orderBy index: r.desc 'createdAt'
      if status != 'all'
        query = query.filter status: status
    crudRead query
    # dfd = q.defer()

    # query
    #   .run()
    #   .then (todos)->
    #     console.log 'TODOS >>>>', todos
    #     dfd.resolve todos
    #   .catch (e)->
    #     handleErr 'GETTING TODOS', e.message, dfd
    # dfd.promise

  ##### editTodo #####
  # Updates the specified todo with the changes given
  # @params: id -> string
  # @params: changes -> object
  # @returns: promise
  # @resolves: object
  editTodo: (id, changes)->
    query = Todo.get id
    crudUpdate query, changes
    # dfd = q.defer()
    # Todo
    #   .get id
    #   .update changes
    #   .run()
    #   .then (result)->
    #     dfd.resolve result
    #   .catch (e)->
    #     handleErr 'UPDATING TODO', e.message, dfd
    # dfd.promise


  ##### deleteTodo #####
  # Removes the specified todo
  # @params: string
  # @returns: promise
  # @resolves: undefined
  deleteTodo: (id)->
    crudDelete Todo, id
    # dfd = q.defer()
    # Todo
    #   .get id
    #   .delete()
    #   .run()
    #   .then (result)->
    #     console.log "DELETED TODO #{id}"
    #     dfd.resolve()
    #   .catch (e)->
    #     handleErr 'DELETING TODO', e.message, dfd
    # dfd.promise
