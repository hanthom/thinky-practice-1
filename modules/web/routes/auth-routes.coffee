passport = require 'passport'
module.exports = (app) ->
  app.route '/api/auth/local'
    .post passport.authenticate 'localLogin',
      successRedirect: '/#/thankyou'
      failureRedirect: '/'
      # failureFlash: true
