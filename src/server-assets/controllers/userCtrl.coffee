q = require 'q'
crudHelper = require "#{__dirname}/../helpers/crudHelper"

{handleErr, trimResponse} = require "#{__dirname}/../helpers/utilsHelper"
{User} = require '../models/models'
{db} = require "#{__dirname}/../config/dbConfig"
{r} = db
{crudCreate, crudRead, crudUpdate, crudDelete} = crudHelper

module.exports =
  ##### createUser #####
  # Creates new user
  # @params: object
  # @returns: promise
  createUser: (user) ->
    crudCreate User, user
      .then (user)->
        module.exports.getOneUser user.username

  ##### getOneUser #####
  # Gathers information for unique user
  # @params: string
  # @returns: promise
  getOneUser: (username) ->
    dfd = q.defer()
    query = User
      .filter username: username
    crudRead query
      .then (user)->
        user = user[0]
        if user
          trimmedUser = trimResponse user, ['password', 'id']
          dfd.resolve trimmedUser
        else
          dfd.reject msg: 'NO USER FOUND', status: 404
      .catch (e)->
        dfd.reject e
    dfd.promise

  ##### getAllUsers #####
  # Gather Information about User or Users
  # @params: obj
  # @resolves: array
  getUsers: () ->
    dfd = q.defer()
    query = User.orderBy index: r.desc 'username'
    crudRead query
      .then (users)->
        if users.length >= 1
          trimmedUsers = []
          for user in users
            trimmedUsers.push trimResponse user, ['password', 'id']
          dfd.resolve trimmedUsers
        else
          dfd.reject msg: 'NO USERS FOUND', status: 404
      .catch (e)->
        dfd.reject e
    dfd.promise

  ##### updateUser #####
  # Updates specific users
  # @params: string, object
  # @returns:
  updateUser: (id, changes)->
    query = User.get id
    crudUpdate query, changes

  ##### deleteUser #####
  # Deletes user permanently
  # @params: string
  # @returns: promise
  deleteUser : (id)->
    crudDelete User, id
