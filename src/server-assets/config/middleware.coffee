bodyParser = require 'body-parser'
{logger} = require "#{__dirname}/serverConfig"

module.exports = (app)->
  app.use bodyParser.json()
  app.use logger
