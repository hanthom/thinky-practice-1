thinky = require 'thinky'

dbName = 'thinky_practice'
if process.env.NODE_ENV is 'development'
  dbName = "#{dbName}_DEV"

db = thinky db: dbName
module.exports = db