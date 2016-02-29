{db} = require "#{__dirname}/../config/dbConfig"
{type, r} = db

User = db.createModel 'User',
  email: type.string()
  username: type.string()
  password: type.string()
  createdAt: type.date().default r.now

User.ensureIndex 'username'
User.pre 'save', (next) ->
  bcrypt = require 'bcrypt'
  @username = @username.toLowerCase()
  console.log "TURN DOWN FOR WHAT"
  bcrypt.genSalt 12, (err, salt) ->
    bcrypt.hash @password, salt, (err, hash) ->
      console.log "HASH >>>> ", hash
      @password = hash
    next()

module.exports = User
