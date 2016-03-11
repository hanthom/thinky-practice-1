passport = require 'passport'
authCtrl = require "#{__dirname}/../controllers/authCtrl"

{sendErr} = require "#{__dirname}/../helpers/utilsHelper"
{localLogin, logout} = authCtrl

module.exports = (app) ->
  app.route '/api/auth/local'
    .post passport.authenticate 'localLogin',
      successRedirect: '/#/thankyou'
      failureRedirect: '/'
      # failureFlash: true
