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
      dfd.promise

    @crudRead = (url, obj) ->
      dfd = $q.defer()
      $http
        .get url, obj
        .then (res) ->
          console.log "CRUD READ RESPONSE >>>> ", res
          dfd.resolve()
      dfd.promise

    @crudUpdate = (obj) ->
      dfd = $q.defer()
      $http
        .post url, obj
        .then (res) ->
          console.log "CRUD UPDATE RESPONSE >>>> ", res
          dfd.resolve()
      dfd.promise

    @crudDelete = (obj) ->
      dfd = $q.defer()
      

module.exports = CrudService
