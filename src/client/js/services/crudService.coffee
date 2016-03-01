url = "/api/users"
crudHelper = require "../helpers/crudHelper"
{crudCreate, crudRead} = crudHelper


new class CrudService
  constructor: ($http, $q)->

    @crudCreate = (url, obj) ->
      dfd = $q.defer()
      $http
        .post url, obj
        .then (res) ->
          console.log "CRUD CREATE RESPONSE >>>> ", res
          dfd.resolve()
        .catch (err) ->
          console.log "CRUD DELETE ERROR >>>> ", err
      dfd.promise

    @crudRead = (url, obj) ->
      dfd = $q.defer()
      $http
        .get url, obj
        .then (res) ->
          console.log "CRUD READ RESPONSE >>>> ", res
          dfd.resolve()
        .catch (err) ->
          console.log "CRUD DELETE ERROR >>>> ", err
      dfd.promise

    @crudUpdate = (obj) ->
      dfd = $q.defer()
      $http
        .put url, obj
        .then (res) ->
          console.log "CRUD UPDATE RESPONSE >>>> ", res
          dfd.resolve()
        .catch (err) ->
          console.log "CRUD DELETE ERROR >>>> ", err
      dfd.promise

    @crudDelete = (url, obj) ->
      dfd = $q.defer()
      $http
        .delete url, obj
        .then (res) ->
          console.log "CRUD DELETE RESPONSE >>>> ", res
        .catch (err) ->
          console.log "CRUD DELETE ERROR >>>> ", err


module.exports = CrudService
