app = require "#{__dirname}/app"
act = require "#{__dirname}/config/seneca_config"
{port} = require "#{__dirname}/config/server_config"
server = app.listen port, (e)->
  if e
    errOpts =
      role: 'util'
      cmd: 'handleErr'
      message: "Could not start server on #{port}"
      service: 'express web app'
    console.log "ERROR LISTENING ON PORT #{port}", e
    act errOpts, 'util'
  else
    logOpts =
      role: 'util'
      cmd: 'log'
      type: 'general'
      message: "Express server started on port #{port}"
    act logOpts, 'util'
