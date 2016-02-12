thinky = require 'thinky'
q = require 'q'
{readFile} = require 'fs'

dbName = 'thinky_practice'
{authKey, port} = require("#{__dirname}/../../../config/secrets").compose
if process.env.NODE_ENV is 'development'
  dbName = "#{dbName}_DEV"

db = {}

createTunnel = ()->
  dfd = q.defer()
  readFile "#{__dirname}/ca_cert.key", (err, caCert)->
    if err then dfd.reject err
    else
      dbConfig =
        db: dbName
        host: 'localhost'
        port: port
        authKey: authKey
        ssl:
          ca: caCert
      db = thinky dbConfig
      dfd.resolve db
  dfd.promise

getDb = ()->
  dfd = q.defer()
  if db then db
  else
    createTunnel()
      .then (db)->
        console.log 'DB CONNECTED >>>> '

module.exports = getDb