q = require 'q'
crudHelper = require "#{__dirname}/../helpers/crudHelper"

{handleErr} = require "#{__dirname}/../helpers/utilsHelper"
{User} = require '../models/models'
{db} = require "#{__dirname}/../config/dbConfig"
{r} = db

module.exports =
  ##### createUser #####
  # Creates new user
  # @params: object
  # @returns: promise
  createUser: (user) ->
    crudHelper.crudCreate User, user

  ##### getOneUser #####
  # Gathers information for unique user
  # @params: string
  # @returns: promise
  getOneUser: (id) ->
    crudHelper.crudRead User.get id

  ##### getAllUsers #####
  # Gathers information for ALL users
  # @params: string
  # @returns: promise
  getAllUsers: (id) ->

  ##### updateUser #####
  # Updates specific users
  # @params: string, object
  # @returns:
  updateUser : (id, changes)->
    query = User.get id
    crudHelper.crudUpdate query, chages

  ##### deleteUser #####
  # Deletes user permanently
  # @params: string
  # @returns: promise
  deleteUser : (id)->
    crudHelper.crudDelete User, id
