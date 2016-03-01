thinky = require 'thinky'
opts =
  db: process.env.DB_NAME
  host: process.env.DB_HOST
  port: process.env.DB_PORT
  authKey: process.env.SSH_TUNNEL_AUTHKEY


console.log "OPTIONS", opts

#
# db = thinky opts
#
# {r} = db
# #
# thing = () ->
#   r
#     .table('User')
#     .delete()
#     .run()
#     .then () ->
#       console.log "ERASED USERS TABLE"
#
# thing()
