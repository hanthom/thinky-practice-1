LocalStrategy = require('passport-local').Strategy
bcrypt = require 'bcrypt'

module.exports =
  logout: (req, res, next) ->
    req.logout()
    next()
  ######
  # Calls createUser after checking that email and username are unclaimed.
  ######
  localSignup: new LocalStrategy
    passReqToCallback: true,
    (req, username, password, done)->
      newUser = req.body
      userCtrl.getUserByUsername username
        .then (user1)->
          console.log 'USER 1'
          if user1
            done null, false, msg: 'username', status: 400
        .catch (e)->
          if e.status is 404
            ######
            # No user found so we check the email now
            ######
            userCtrl.getUserByEmail newUser.email
              .then (user)->
                if user
                  done null, false,  msg: 'email', status: 400
              .catch (e)->
                if e.status is 404
                  ######
                  # If there's not a user with email/ username create a user.
                  ######
                  userCtrl.createUser newUser
                    .then (user)->
                      done null, user
                    .catch (e)->
                      done e, false
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
          done null, false, 'Invalid password'
        else
          done null, res
      .catch (err) ->
        if err.status is 404
          done null, false, 'Wrong username'
        else
          done err, false, 'Server Error'
