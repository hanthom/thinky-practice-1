bodyParser = require 'body-parser'
{logger}   = require "#{__dirname}/serverConfig"
express    = require 'express'
cors       = require 'cors'
passport   = require 'passport'
session    = require 'express-session'

module.exports = (app)->
  ######
  # Sets up the initial get request
  app.use express.static "#{__dirname}/../../client"
  app.use bodyParser.json()
  app.use cors()
  # app.use session
  app.use passport.initialize()
  app.use passport.session()


  if process.env.WATCH_SERVER
    app.use logger
