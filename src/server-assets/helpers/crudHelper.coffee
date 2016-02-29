q = require 'q'

module.exports =

  crudCreate: (modelObj, insert) ->
    dfd = q.defer()
    new modelObj insert
      .save()
      .then (res) ->
        console.log 'CRUD CREATE >>>> ', res
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD CREATE ERROR >>>> ', err.message
    dfd.promise

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

  crudUpdate: (query, changes) ->
    dfd = q.defer()
    query
      .update changes
      .run()
      .then (res) ->
        console.log 'CRUD EDIT >>>> ', get
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD EDIT ERROR >>>> ', err.message
    dfd.promise

  crudDelete: (modelObj, id) ->
    dfd = q.defer()
    modelObj
      .get id
      .delete()
      .run()
      .then (res) ->
        console.log "CRUD DELETE #{get}"
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD DELETE ERROR >>>> ', err.message
    dfd.promise
