q          = require 'q'
crudHelper = require "#{__dirname}/../helpers/crudHelper"

{User}                    = require '../models/models'
{db, r}                      = require "#{__dirname}/../config/dbConfig"
{handleErr, trimResponse} = require "#{__dirname}/../helpers/utilsHelper"


{crudCreate, crudRead, crudUpdate, crudDelete} = crudHelper

module.exports =

################################################################################
#                          USER ENDPOINT FUNCTIONS                             #
################################################################################


  ##### createUser #####
  # Creates new user
  # @params: object
  # @returns: promise
  createUser: (user) ->
    dfd = q.defer()
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
    dfd = q.defer()
    if !username
      dfd.reject msg: 'Provide a username', status: 400
    else
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
  # @resolves: object
  getUserByEmail:(email)->
    dfd = q.defer()
    if !email
      dfd.reject msg: 'Provide an email', status: 400
    else
      query = User
        .filter email: email
      crudRead query
        .then (res)->
          user = res[0]
          if user
            trimResponse user, ['password', 'id']
            dfd.resolve user
          else
            dfd.reject msg: 'NO EMAIL FOUND', status: 404
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
  deleteUser: (id)->
    crudDelete User, id

################################################################################
#                            USER SERVER FUNCTIONS                             #
################################################################################

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
        dfd.resolve user.password
      .catch (err) ->
        dfd.reject msg: 'NO USER FOUND', status: 404
    dfd.promise
