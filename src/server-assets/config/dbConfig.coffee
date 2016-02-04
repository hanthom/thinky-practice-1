thinky = require 'thinky'
fs = require 'fs'
{dbAuthKey} = require '../secrets'

dbName = 'thinky_practice'

if process.env.NODE_ENV is 'development'
  dbName = "#{dbName}_DEV"

dbConfig =
  db: dbName
  host: 'localhost'
  port: 27000


module.exports = thinky dbConfig