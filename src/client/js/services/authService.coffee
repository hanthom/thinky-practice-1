q = require 'q'
url = '/api/auth'
new class AuthService
  constructor: ($http, $q)->
    @login = (credentials)->
      $http
        method: 'POST'
        url: "#{url}/local"
        data: credentials
    @getAuth = ()->
      dfd = $q.defer()
      $http
        .get 'api/user'
        .then (res)->
          console.log 'Response getting user', res
          if res.data is '0'
            msg = 'Invalid username.'
            console.log msg
            dfd.reject msg
          else
            dfd.resolve res.data
      dfd.promise
    @logout = ()->
      $http
        .get "#{url}/logout"

module.exports = AuthService
