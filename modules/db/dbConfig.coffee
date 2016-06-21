######
# Exports one instance of thinky so tables are shared
######
thinky = require 'thinky'

opts =
  db: 'test_db'
  host: 'rethinkdb'

db = thinky opts

module.exports =
  config: opts
  db: db
  r: db.r
