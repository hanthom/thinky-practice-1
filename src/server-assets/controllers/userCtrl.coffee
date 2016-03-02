q = require 'q'
crudHelper = require "#{__dirname}/../helpers/crudHelper"

{handleErr} = require "#{__dirname}/../helpers/utilsHelper"
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
    query = User.filter username: username
    crudRead query
      .then (userArr)->
        console.log 'USERS RETURNED >>>>', userArr
        dfd.resolve userArr[0]
      .catch (e)->
        dfd.reject e
    dfd.promise
    # dfd = q.defer()
    # User
    #   .get id
    #   .run()
    #   .then (user) ->
    #     console.log "USER >>>> ", user
    #     dfd.resolve user
    #   .catch (err) ->
    #     handleErr "GETTING USER >>>> ", err.message, dfd

  ##### getAllUsers #####
  # Gather Information about User or Users
  # @params: obj
  # @returns: promise
  getUsers: () ->
    dfd = q.defer()
    query = User.orderBy index: r.desc 'username'
    crudRead query
      .then (users)->
        if users.length >= 1
          dfd.resolve users
        else
          dfd.resolve()
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
