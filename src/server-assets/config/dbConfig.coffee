thinky = require 'thinky'
q = require 'q'
{readFile} = require 'fs'

db = {}
dbName = 'thinky_practice'
dbConfig =
  dbName: dbName
  host: process.env.host
  port: process.env.port
  authKey: process.env.authKey

if process.env.NODE_ENV is 'development'
  {authKey, host, sshPort} = require "#{__dirname}/../../../config/secrets"
  dbconfig =
    dbName: "#{dbName}_DEV"
    host: host
    port: port
    authKey: authKey

getCert = (path)->
  dfd = q.defer()
  readFile "#{__dirname}/#{path}", (e, caCert)->
    if e
      console.log "ERROR WITH FILE READ >>>> #{e}"
      dfd.reject e.message
    else
      dfd.resolve caCert
  dfd.promise

createDb = ()->
  getCert dbConfig.certPath
  dbConfig.ssl = ca: caCert
  db = thinky dbConfig
  dfd.resolve db  

module.exports =
  getDb: ()->
    if db is !{}
      db
    else
      dfd = q.defer()
      createTunnel()
        .then (db)->
          console.log 'DB CONNECTED'
          dfd.resolve db
        .catch (e)->
          dfd.reject e
      dfd.promise