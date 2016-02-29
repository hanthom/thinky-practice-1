express = require 'express'
{port} = require "#{__dirname}/config/serverConfig"

app = express()
app.listen port, (e)->
  if e
    console.log "SPIN UP ERROR >>>> #{e.message}"
  else
    console.log "SERVER SPUN UP ON PORT #{port}"

# Passes the app to the middleware and routes.
# These files export a function that expects the express app as an argument.
require("#{__dirname}/config/middleware") app
require("#{__dirname}/routes/todo-routes") app
require("#{__dirname}/routes/user-routes") app
