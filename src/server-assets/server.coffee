express = require 'express'
{port} = require "#{__dirname}/config/serverConfig"

app = express()
serverListening = false
app.listen port, (e)->
  if e
    console.log "SPIN UP ERROR >>>> #{e.message}"
  else
    console.log "SERVER SPUN UP ON PORT #{port}"
    serverListening = true

# Passes the app to the middleware and routes.
# These files export a function that expects the express app as an argument.
require("#{__dirname}/config/middleware") app
require("#{__dirname}/routes/todo-routes") app
require("#{__dirname}/routes/user-routes") app

module.exports = app
