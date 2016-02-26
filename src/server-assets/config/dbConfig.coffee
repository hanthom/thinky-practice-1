thinky = require 'thinky'

dbName = 'thinky_practice'
authKey = ''

if process.env.NODE_ENV is 'development'
  dbName = "#{dbName}_DEV"
  authKey = require('../../../config/secrets').dbConfig.authKey

opts =
  db: dbName
  authKey: process.env.SSH_TUNNEL_AUTHKEY || authKey

db = thinky opts

module.exports = db
