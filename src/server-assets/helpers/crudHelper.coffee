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

  crudRead: (modelObj, get) ->
    dfd = q.defer()
    modelObj
      .get get
      .run()
      .then (res) ->
        console.log 'CRUD READ >>>> ', res
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD READ ERROR >>> ', err.message
    dfd.promise

  crudUpdate: (modelObj, get, changes) ->
    dfd = q.defer()
    modelObj
      .get get
      .update changes
      .run()
      .then (res) ->
        console.log 'CRUD EDIT >>>> ', get
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD EDIT ERROR >>>> ', err.message
    dfd.promise

  crudDelete: (modelObj, get) ->
    dfd = q.defer()
    modelObj
      .get get
      .delete()
      .run()
      .then (res) ->
        console.log "CRUD DELETE #{get}"
        dfd.resolve res
      .catch (err) ->
        console.log 'CRUD DELETE ERROR >>>> ', err.message
    dfd.promise
