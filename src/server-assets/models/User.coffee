{db} = require "#{__dirname}/../config/dbConfig"
{type, r} = db
{trimResponse} = require "#{__dirname}/../helpers/utilsHelper"

##### User Model #####
# Schema for User
User = db.createModel 'User',
  email: type.string()
  username: type.string()
  password: type.string()
  createdAt: type.date().default r.now
  # validation:
  #   validated: type.boolean()
  #   valdiationKey: type.string()

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
  # @validation.validated = false
  # @validation.validationKey = bcrypt.genSaltSync(20)
  next()

module.exports = User
