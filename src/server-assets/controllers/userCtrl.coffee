{User} = require '../models/models'
q = require 'q'

{r} = require "#{__dirname}/../config/dbConfig"

##### handleErr #####
# Creates a log message and rejects promise with log
# @params: action -> string
# @params: message -> string
# @params: promise -> q.defer object
handleErr = (action, message, promise)->
  log = "ERROR #{action} >>>> #{message}"
  console.log log
  promise.reject log

module.exports =
  #---------#
  # createUser
  # Creates new user on register
  # @params: object
  # @returns: promise
  createUser: (user) ->
    dfd = q.defer()
    new User user
      .save()
      .then (doc) ->
        console.log 'USER ADDED >>>>', doc
        dfd.resolve doc
      .catch (err) ->
        handleErr 'ADDING USER >>>>', err.message, dfd
      dfd.promise

  #---------#
  # readUser
  # Gather user information
  # @params: string
  # @returns: promise
  getOneUser: (id) ->
    dfd = q.defer()
    User
      .get id
      .run()
      .then (user) ->
        console.log 'USER >>>>', user
        dfd.resolve user
      .catch (err) ->
        handleErr 'READING USER >>>>', err.message, dfd
    dfd.promise

  #---------#
  # readAllUsers
  # Gather all users
  # @params: status
  # @returns: promise
  getAllUsers: (id) ->
    dfd = q.defer()
    query = User
      .orderBy index: r.desc 'createdAt'
    if status != 'all'
      query = query.filter id: id
    query
      .run()
      .then (users) ->
        console.log 'USERS >>>>>', users
      .catch (err) ->
        handleErr 'GETTING USERS >>>>', err.message, dfd
    dfd.promise
  #---------#
  # updateUser
  # Updates user information
  # @params: string
  # @returns: promisee
  updateUser : (id, changes)->
    dfd = q.defer()
    User
      .get id
      .update changes
      .run()
      .then (res) ->
        dfd.resolve res
      .catch (err) ->
        handleErr 'UPDATING USER', err.message, dfd
    dfd.promise

  #---------#
  # deleteUser
  # Removes user from database
  # @params: string
  # @returns: boolean
  deleteUser : (id)->
    dfd = q.defer()
    User
      .get id
      .delete()
      .run()
      .then (res) ->
        console.log "USER DELETED #{id}"
      .catch (err) ->
        handleErr 'DELETING USER', err.message, dfd
