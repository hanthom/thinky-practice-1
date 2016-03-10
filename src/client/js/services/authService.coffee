url = '/api/auth'

new class AuthService
  constructor: ($http, $q) ->
    @localLogin = (user) ->
      $http
        .post "#{url}/local", user
        .then (res) ->
          console.log "response from auth local >>>", res
        .catch (err) ->
          console.log "error from auth local >>>", err

module.exports = AuthService
