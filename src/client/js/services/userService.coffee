url = '/api/user'
new class UserService
  constructor: ($http, $q)->
    @addUser =  (user)->
      dfd = $q.defer()
      $http
        .post url, user
        .then (res)->
          console.log res
          dfd.resolve()
      dfd.promise

module.exports = UserService
