{db} = require "#{__dirname}/../config/dbConfig"
{type, r} = db

##### User Model #####
# Schema for User
User = db.createModel 'User',
  email: type.string()
  username: type.string()
  password: type.string()
  createdAt: type.date().default r.now

##### Ensures Username for User #####
User.ensureIndex 'username'

##### Pre Save Func #####
# Hashes Password and lowercases Username
# @params: string, func
# @returns: func
User.pre 'save', (next) ->
  bcrypt = require 'bcrypt'
  @username = @username.toLowerCase()
  @password = bcrypt.hashSync @password, 12
  next()


##### Exports User #####
module.exports = User
