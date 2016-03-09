url = "/api/users"

new class UserService
  constructor: ($http, $q)->
    @addUser =  (user)->
      $http
        .post url, user
        .then (res) ->
          console.log "response from server >>> ", res
          res.data
        .catch (err) ->
          $q.reject err

module.exports = UserService
