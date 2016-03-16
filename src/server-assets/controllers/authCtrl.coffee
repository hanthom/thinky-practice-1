q             = require 'q'
userCtrl      = require "#{__dirname}/../controllers/userCtrl"
LocalStrategy = require('passport-local').Strategy
bcrypt        = require 'bcrypt'

{handleErr, sendErr} = require "#{__dirname}/../helpers/utilsHelper"
{User}      = require '../models/models'

{getUserByUsername, getUserPassword} = userCtrl

module.exports =
  logout: (req, res, next) ->
    req.logout()
    next()
  ######
  # Calls createUser after checking that email and username are valid.
  ######
  localSignup: new LocalStrategy
    passReqToCallback: true,
    (req, username, password, done)->
      console.log 'PASSPORT SEES ---->'
      console.log "username: #{username}"
      console.log "password: #{password}"
      newUser = req.body
      userCtrl.getUserByUsername username
        .then (user)->
          if user
            done null, false, {message: "'#{username}' is already taken"}
        .catch (e)->
          if e.status is 404
            ######
            # No user found so we check the email now
            ######
            userCtrl.getUserByEmail newUser.email
              .then (user)->
                if user
                  done null, false, {message: "'#{newUser.email}' is taken"}
              .catch (e)->
                if e.status is 404
                  ######
                  # If there's not a user with email/ username create a user.
                  ######
                  userCtrl.createUser newUser
                    .then (user)->
                      done null, user
                else
                  done e, false
          else
            done e, false
  ######
  # Finds the user and compares passwords
  # Only login if user found and passwords match
  ######
  localLogin: new LocalStrategy (username, password, done) ->
    getUserByUsername username
    .then (res) ->
      if !bcrypt.compareSync password, res
        console.log "Failed Password"
        done null, false, {message: 'Invalid password'}
      else
        done null, res
    .catch (err) ->
      if err.status is 404
        done null, false, {message: 'Wrong username'}
      else
        done err, false, {message: 'Server Error'}
