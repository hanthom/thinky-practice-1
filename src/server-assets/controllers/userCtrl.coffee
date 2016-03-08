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
    module.exports.getOneUser user.username
    .then () ->
      console.log "User Exists"
      q.reject('exists')
    , () ->
      crudCreate User, user

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
          trimResponse user, ['password', 'id', 'email']
          dfd.resolve user
        else
          dfd.reject msg: 'NO USER FOUND', status: 404
      .catch (e)->
        dfd.reject e
    dfd.promise

  ##### getUserByEmail #####
  # Gets user by email
  # @params: string
  # @returns: promise
  getUserByEmail:(email)->
    dfd = q.defer()
    query = User
      .filter email: email
    crudRead query
      .then (user)->
        user = user[0]
        if user
          trimResponse user, ['password', 'id']
          console.log user
          dfd.resolve user
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
    query = User.orderBy index: r.asc 'username'
    crudRead query
      .then (users)->
        if users.length >= 1
          trimmedUsers = []
          for user in users
            trimmedUsers.push trimResponse user, ['password', 'id', 'email']
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
