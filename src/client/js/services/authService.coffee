url = '/api/auth'

new class AuthService
  constructor: ($http, $q) ->
    @localLogin = (user) ->
      dfd = $q.defer()
      $http
        .post "#{url}/local", user
        .then (res) ->
          console.log "response from server >>>", $q.resolve res
          dfd.resolve res
        .catch (err) ->
          dfd.reject err
      dfd.promise

module.exports = AuthService
