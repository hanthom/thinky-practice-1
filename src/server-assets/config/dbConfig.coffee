thinky = require 'thinky'

dbName = 'thinky_practice'
{authKey, port} = require("#{__dirname}/../../../secrets").compose
if process.env.NODE_ENV is 'development'
  dbName = "#{dbName}_DEV"

dbConfig =
  db: dbName
  host: 'localhost'
  port: port
  authKey: authKey


module.exports = thinky dbConfig