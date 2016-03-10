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
    console.log "USER >>> ", user
    dfd = q.defer()
    module.exports.getUserByUsername user.username
    .then (res) ->
      console.log "RES FROM getUserByUsername >>> ", res
      dfd.reject msg: "Username Exists", status: 403
    .catch (err) ->
      module.exports.getUserByEmail user.email
      .then (res) ->
        dfd.reject msg: "Email Exists", status: 403
      .catch (err) ->
        crudCreate User, user
        .then (res) ->
          dfd.resolve res
        .catch (err) ->
          dfd.reject msg: "Welp, this is awkward", status: 418
    dfd.promise

  ##### getUserByUsername #####
  # Gathers information for unique user
  # @params: string
  # @returns: promise
  getUserByUsername: (username) ->
    console.log "USERNAME >>> ", username
    dfd = q.defer()
    query = User
      .filter username: username
    crudRead query
      .then (res)->
        user = res[0]
        if user
          trimResponse user, ['password', 'id']
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
      .then (res)->
        user = res[0]
        if user
          trimResponse user, ['password', 'id']
          console.log user
          dfd.resolve user
        else
          dfd.reject msg: 'NO EMAIL FOUND', status: 404
      .catch (e)->
        dfd.reject e
    dfd.promise

  ##### getPassword #####
  # Get user password
  # @params: string, string
  # @returns: promise
  getUserPassword: (username)->
    dfd = q.defer()
    query = User
      .filter username: username
    crudRead query
      .then (res) ->
        user = res[0]
        trimResponse user, ['id', 'email', 'createdAt']
        dfd.resolve user.password
      .catch (err) ->
        dfd.reject msg: 'NO USER FOUND', status: 404
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
        trimmedUsers = []
        for user in users
          trimmedUsers.push trimResponse user, ['password', 'id', 'email']
        dfd.resolve trimmedUsers
      .catch (e)->
        dfd.reject msg: 'NO USERS FOUND', status: 404
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
