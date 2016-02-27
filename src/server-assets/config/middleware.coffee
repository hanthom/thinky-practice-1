bodyParser = require 'body-parser'
{logger} = require "#{__dirname}/serverConfig"

module.exports = (app)->
  app.use express.static "#{__dirname}/../client"
  app.use bodyParser.json()
  app.use logger
