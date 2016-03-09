url = "/api/users"

new class UserService
  constructor: ($http, $q)->
    @addUser =  (user)->
      # dfd = $q.defer()
      $http
        .post url, user
        .then (res) ->
          console.log "response from server >>> ", res.data
          res.data
        , () ->
          console.log "no response from server"

module.exports = UserService
