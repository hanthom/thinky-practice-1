# Sets the dbName and only requires 'secrets' file if in env not available
# Exports one instance of thinky so tables are shared
thinky = require 'thinky'
authKey = ''
dbName = 'thinky_practice'
if process.env.NODE_ENV is 'development'
  dbName = "#{dbName}_DEV"
if !process.env.SSH_TUNNEL_AUTHKEY
  path = "#{__dirname}/../../../config/secrets.coffee"
  authKey = require(path).dbConfig.authKey

opts =
  db: dbName
  host: process.env.DB_HOST || 'localhost'
  port: process.env.DB_PORT || 28015
  authKey: process.env.SSH_TUNNEL_AUTHKEY || authKey

db = thinky opts

module.exports =
  db: db
  config: opts
