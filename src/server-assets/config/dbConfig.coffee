thinky = require 'thinky'
q = require 'q'
{readFile} = require 'fs'

db = false
dbName = 'thinky_practice'
dbConfig =
  dbName: dbName
  host: process.env.host
  port: process.env.port
  authKey: process.env.authKey

if process.env.NODE_ENV is 'development'
  {dbConfig} = require "#{__dirname}/../../../config/secrets"
  dbConfig.dbName = "#{dbName}_DEV"

createDb = ()->
  dfd = q.defer()
  readFile "#{__dirname}/sslCert.crt", (e, caCert)->
    if e
      console.log "ERROR WITH FILE READ >>>>", e
      dfd.reject e.message
    else
      dbConfig.ssl = ca: caCert
      db = thinky dbConfig
      console.log db
      dfd.resolve db
  dfd.promise

module.exports = ()->
  if db
    db
  else
    dfd = q.defer()
    createDb()
      .then (db)->
        console.log 'DB CONNECTED'
        dfd.resolve()
      .catch (e)->
        dfd.reject e
    dfd.promise