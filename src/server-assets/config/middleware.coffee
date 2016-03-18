bodyParser    = require 'body-parser'
express       = require 'express'
cors          = require 'cors'
passport      = require 'passport'
session       = require 'express-session'
sessionSecret = require "#{__dirname}/secrets"
authCtrl      = require "#{__dirname}/../controllers/authCtrl"

{User}        = require "#{__dirname}/../models/models"
{logger, port}      = require "#{__dirname}/serverConfig"
{localLogin, localSignup}  = authCtrl

corsOpts =
  origin: "http://localhost:#{port}"

module.exports = (app)->

  app.use express.static "#{__dirname}/../../client"
  app.use bodyParser.json()
  app.use cors corsOpts
  app.use session sessionSecret
  app.use passport.initialize()
  app.use passport.session()
  app.use logger

  passport.serializeUser (user, done) ->
    done null, user

  passport.deserializeUser (username, done) ->
    User.filter {username: username}
      .then (res) ->
        done null, res
      .catch (err) ->
        done err, false

  passport.use 'localLogin', localLogin
  passport.use 'localSignup', localSignup
