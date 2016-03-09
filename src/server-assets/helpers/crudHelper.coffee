q = require 'q'

module.exports =
  ##### crudCreate #####
  # Creates an item on the DB
  # @params: modelObj -> Thinky Model
  # @params: insert -> object
  # @resolves: object
  crudCreate: (modelObj, insert) ->
    dfd = q.defer()
    new modelObj insert
      .save()
      .then (res) ->
        # console.log 'CRUD CREATE >>>> ', res
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD CREATE ERROR >>>> ', err.message
    dfd.promise

  ##### crudRead #####
  # Gets the requested info from the DB
  # @params: query -> Thinky Query
  # @resolves: Object or Array based on query
  crudRead: (query) ->
    dfd = q.defer()
    query
      .run()
      .then (res) ->
        console.log 'CRUD READ >>>> ', res
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD READ ERROR >>> ', err.message
    dfd.promise

  ##### crudUpdate #####
  # Updates the queried doc(s) with the changes
  # @params: query -> Thinky Query
  # @resolves: Updated object or array of updated objects
  crudUpdate: (query, changes) ->
    dfd = q.defer()
    query
      .update changes
      .run()
      .then (res) ->
        # console.log 'CRUD EDIT >>>> ', get
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD EDIT ERROR >>>> ', err.message
    dfd.promise

  ##### crudDelete #####
  # Deletes the specifed object
  # @params: modelObj -> Thinky Model
  # @params: id -> string
  # @resolves: Object
  crudDelete: (modelObj, id) ->
    dfd = q.defer()
    modelObj
      .get id
      .delete()
      .run()
      .then (res) ->
        # console.log "CRUD DELETE"
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD DELETE ERROR >>>> ', err.message
    dfd.promise
