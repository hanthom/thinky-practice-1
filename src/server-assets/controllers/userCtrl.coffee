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
        console.log "GETTING #{user.id}"
        module.exports.getOneUser user.id

  ##### getOneUser #####
  # Gathers information for unique user
  # @params: string
  # @returns: promise
  getOneUser: (id) ->
    crudRead User.get id

  ##### getAllUsers #####
  # Gather Information about User or Users
  # @params: obj
  # @returns: promise
  getUsers: (filter) ->
    query = User
      .orderBy index: r.desc 'username'
      if filter != 'all'
        query = query.filter username: filter
    crudRead query.trimUser()


  ##### updateUser #####
  # Updates specific users
  # @params: string, object
  # @returns:
  updateUser : (id, changes)->
    query = User.get id
    crudUpdate query, chages

  ##### deleteUser #####
  # Deletes user permanently
  # @params: string
  # @returns: promise
  deleteUser : (id)->
    crudDelete User, id
