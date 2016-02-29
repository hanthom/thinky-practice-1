q = require 'q'
crudHelper = require "#{__dirname}/../helpers/crudHelper"

{handleErr} = require "#{__dirname}/../helpers/utils"
{User} = require '../models/models'
{db} = require "#{__dirname}/../config/dbConfig"
{r} = db

module.exports =
  #---------#
  # createUser
  # Creates new user on register
  # @params: object
  # @returns: promise
  createUser: (user) ->
    crudHelper.crudCreate User, user

  #---------#
  # readUser
  # Gather user information
  # @params: string
  # @returns: promise
  getOneUser: (id) ->
    crudHelper.crudRead User.get id

  #---------#
  # readAllUsers
  # Gather all users
  # @params: status
  # @returns: promise
  getAllUsers: (id) ->

  #---------#
  # updateUser
  # Updates user information
  # @params: string
  # @returns: promisee
  updateUser : (id, changes)->
    query = User.get id
    crudHelper.crudUpdate query, chages

  #---------#
  # deleteUser
  # Removes user from database
  # @params: string
  # @returns: boolean
  deleteUser : (id)->
    crudHelper.crudDelete User, id
