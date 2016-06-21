passport = require 'passport'
q = require 'q'
act = require "#{__dirname}/../config/seneca_config"
module.exports = (app) ->
  app.route '/api/users/:username'
    .get (req, res)->
      getOpts =
        role: 'users'
        cmd: 'get'
        type: 'username'
        username: req.params.username
      act getOpts, 'users'
      .then (user)->
        res
          .status 200
          .send user
      .catch sendErr res

  app.route '/api/users/email/:email'
    .get (req, res) ->
      getOpts =
        role: 'users'
        cmd: 'get'
        type: 'email'
        email: req.params.email
      act getOpts, 'users'
      .then (user)->
        res
          .status 200
          .send user
      .catch sendErr res

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
