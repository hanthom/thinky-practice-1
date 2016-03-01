url = "/api/users"

new class UserService
  constructor: ($http, $q, crudService)->
    @addUser =  (user)->
      crudService.crudCreate url, user

module.exports = UserService
