bodyParser = require 'body-parser'
{logger} = require('./config/config').server

module.exports = (app)->
  app.use bodyParser.json()
  app.use logger
