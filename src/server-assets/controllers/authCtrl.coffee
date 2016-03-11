q = require 'q'
userCtrl = require "#{__dirname}/../controllers/userCtrl"
LocalStrategy = require('passport-local').Strategy
bcrypt = require 'bcrypt'

{handleErr} = require "#{__dirname}/../helpers/utilsHelper"
{User} = require '../models/models'
{getUserByUsername, getUserPassword} = userCtrl

module.exports =
  logout: (req, res, next) ->
    req.logout()
    next()

  localLogin: new LocalStrategy (username, password, done) ->
    getUserByUsername username
    .then (res) ->
      getUserPassword res.username
      .then (res) ->
        if !bcrypt.compareSync password, res
          console.log "Failed Password"
          done null, false, {message: 'Invalid password'}
        else
          done null, res
      .catch (err) ->
        done null, false, {message: 'Error getting password'}
    .catch (err) ->
      done null, false, {message: 'Wrong username'}
