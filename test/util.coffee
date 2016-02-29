faker = require 'faker'

class Util
  @pristineUser: ()->
    newUser =
      password: 'test'
      username: faker.name.firstName()

module.exports = Util
