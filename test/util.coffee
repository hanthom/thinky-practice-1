faker = require 'faker'
module.exports =
  dbClean: (table, cb)->
    r.table table
      .filter test: true
      .delete()
      .then (res)->
        console.log 'DB cleaned'
        cb()
  pristineUser: ()->
    newUser =
      password: 'test'
      test: true
      username: faker.name.username()
      email: faker.internet.email()
