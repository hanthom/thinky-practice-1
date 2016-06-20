passport = require 'passport'
q = require 'q'
act = require "#{__dirname}/../config/seneca_config"
module.exports = (app) ->

  app.route '/api/users/:username'
    .get (req, res)->
      getUserByUsername req.params.username
        .then (user) ->
          res
            .status 200
            .send user
        .catch (err) ->
          sendErr err, res

  app.route '/api/users/email/:email'
    .get (req, res) ->
      getUserByEmail req.params.email
        .then (user) ->
          res
            .status 200
            .send user
        .catch (err) ->
          sendErr err, res

  app.route '/api/users'
    .post (req, res, next)->
      passport.authenticate('localSignup', (err, user, info)->
        if err then sendErr err, res
        if info
          if !info.status
            info.status = 400
          sendErr info, res
        if user
          res
            .status 201
            .send user
      )(req, res, next)

    .get (req, res)->
      getUsers()
        .then (users)->
          res
            .status 200
            .send users
        .catch (err)->
          sendErr err, res
