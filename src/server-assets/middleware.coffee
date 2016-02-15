bodyParser = require 'body-parser'
{logger} = require("#{__dirname}/config").server

module.exports = (app)->
  app.use bodyParser.json()
  app.use logger
