faker = require 'faker'
module.exports =
  pristineUser: ()->
    newUser =
      password: 'test'
      test: true
      username: faker.name.firstName()
