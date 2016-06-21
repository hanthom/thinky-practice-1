bodyParser = require 'body-parser'
express = require 'express'
passport = require 'passport'
session = require 'express-session'

{logger, port} = require "#{__dirname}/server_config"
{localLogin, localSignup} = require "#{__dirname}/passport_config"


module.exports = (app)->

  app.use express.static "#{__dirname}/../../client"
  app.use bodyParser.json()
  app.use session
    secret: 'SUPER_SECRET'
    resave: false
    saveUninitialized: false

  app.use passport.initialize()
  app.use passport.session()

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
