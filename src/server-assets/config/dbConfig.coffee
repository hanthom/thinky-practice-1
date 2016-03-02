# Sets the dbName and only requires 'secrets' file if in env not available
# Exports one instance of thinky so tables are shared
thinky = require 'thinky'

opts =
  db: process.env.DB_NAME
  host: process.env.DB_HOST
  port: process.env.DB_PORT
  authKey: process.env.SSH_TUNNEL_AUTHKEY

db = thinky opts

module.exports =
  db: db
  config: opts
