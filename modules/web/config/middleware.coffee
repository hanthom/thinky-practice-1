bodyParser = require 'body-parser'
express = require 'express'
cors = require 'cors'
passport = require 'passport'
session = require 'express-session'

{logger, port} = require "#{__dirname}/server_config"
{localLogin, localSignup} = require "#{__dirname}/passport_config"

corsOpts =
  origin: "http://localhost:#{port}"

module.exports = (app)->

  app.use express.static "#{__dirname}/../../client"
  app.use bodyParser.json()
  app.use cors corsOpts
  app.use session
    secret: process.env.SESSION_SECRET
    resave: false
    saveUninitialized: false

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
