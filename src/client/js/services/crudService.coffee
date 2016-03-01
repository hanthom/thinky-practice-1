url = "/api/users"

new class CrudService
  constructor: ($http, $q)->
    ##### CRUD CREATE #####
    # CRUD Helper method to ADD to API
    # @params: string, obj
    # @returns: obj
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

    ##### CRUD READ #####
    # CRUD Helper method to GATHER from API
    # @params: string, obj
    # @returns: objc
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

    ##### CRUD UPDATE #####
    # CRUD Helper method to UPDATE collection in API
    # @params: string, obj
    # @returns: obj
    @crudUpdate = (url, obj) ->
      dfd = $q.defer()
      $http
        .put url, obj
        .then (res) ->
          console.log "CRUD UPDATE RESPONSE >>>> ", res
          dfd.resolve()
        .catch (err) ->
          console.log "CRUD DELETE ERROR >>>> ", err
      dfd.promise

    ##### CRUD DELETE #####
    # CRUD Helper method to DELETE collection from API
    # @params: string, obj
    # @returns: null
    @crudDelete = (url, obj) ->
      dfd = $q.defer()
      $http
        .delete url, obj
        .then (res) ->
          console.log "CRUD DELETE RESPONSE >>>> ", res
        .catch (err) ->
          console.log "CRUD DELETE ERROR >>>> ", err


module.exports = CrudService
