faker = require 'faker'
module.exports =
  pristineUser: ()->
    newUser =
      password: 'test'
      username: faker.name.firstName()
