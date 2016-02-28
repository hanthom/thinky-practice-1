bodyParser = require 'body-parser'
{logger} = require "#{__dirname}/serverConfig"
express = require 'express'

module.exports = (app)->
  ######
  # Sets up the initial get request
  app.use express.static "#{__dirname}/../../client"
  app.use bodyParser.json()
  app.use logger
