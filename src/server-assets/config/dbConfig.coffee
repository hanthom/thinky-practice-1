######
# Exports one instance of thinky so tables are shared
######
thinky = require 'thinky'

opts =
  authKey: process.env.SSH_TUNNEL_AUTHKEY
  db: process.env.DB_NAME
  host: process.env.DB_HOST
  port: process.env.DB_PORT

db = thinky opts

module.exports =
  config: opts
  db: db
  r: r
