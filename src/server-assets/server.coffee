express = require 'express'
{server, getDb} = require "#{__dirname}/config"
{port} = server

getDb().then ()->
  app = express()
  app.listen process.env.port || port, (e)->
    if e
      console.log "SPIN UP ERROR >>>> #{e.message}"
    else
      console.log "SERVER SPUN UP ON PORT #{port}"

  require('./middleware') app
  require('./routes/todo-routes') app