express = require 'express'
{port} = require("#{__dirname}/server-assets/config").server

app = express()
app.listen process.env.PORT || port, (e)->
  if e
    console.log "SPIN UP ERROR >>>> #{e.message}"
  else
    console.log "SERVER SPUN UP ON PORT #{port}"

require('./server-assets/middleware') app
require('./server-assets/routes/todo-routes') app
