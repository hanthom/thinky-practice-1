app = require "#{__dirname}/app"
port = require("#{__dirname}/config/serverConfig").port

server = app.listen port, (e)->
  if e
    console.log "ERROR LISTENING ON PORT #{port}", e
  else
    console.log "SERVER SPUN UP ON PORT #{port}"

# module.exports = (cb)->
#   server.close ->
#     console.log "Closing server on #{port}"
#     if cb then cb()
