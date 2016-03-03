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

  ##### getOneTodo #####
  # Retrieves one todo from the database
  # @params: string
  # @returns: promise
  # @resolves: object

  getOneTodo: (id)->
    crudRead Todo.get id

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

  ##### editTodo #####
  # Updates the specified todo with the changes given
  # @params: id -> string
  # @params: changes -> object
  # @returns: promise
  # @resolves: object
  editTodo: (id, changes)->
    query = Todo.get id
    crudUpdate query, changes

  ##### deleteTodo #####
  # Removes the specified todo
  # @params: string
  # @returns: promise
  # @resolves: undefined
  deleteTodo: (id)->
    crudDelete Todo, id
