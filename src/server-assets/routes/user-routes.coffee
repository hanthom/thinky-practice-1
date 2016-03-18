passport = require 'passport'
userCtrl = require "#{__dirname}/../controllers/userCtrl"
{createUser, getUserByUsername, getUserByEmail} = userCtrl
{getUsers, updateUser, deleteUser} = userCtrl
{sendErr} = require "#{__dirname}/../helpers/utilsHelper"

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
    .post passport.authenticate 'localSignup',
      successRedirect: '/'
      failureRedirect: '/'
      failureFlash: true
    .get (req, res)->
      getUsers()
        .then (users)->
          res
            .status 200
            .send users
        .catch (err)->
          sendErr err, res
