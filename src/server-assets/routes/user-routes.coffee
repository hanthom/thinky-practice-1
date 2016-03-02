userCtrl = require "#{__dirname}/../controllers/userCtrl"
{createUser, getOneUser, getUsers, updateUser, deleteUser} = userCtrl
{sendErr} = require "#{__dirname}/../helpers/utilsHelper"

module.exports = (app) ->

  app.route '/api/users/:username'
    .get (req, res)->
      getOneUser req.params.username
        .then (user) ->
          if user
            res
              .status 200
              .send user
          else
            res
              .status 404
              .send 'NO USERS FOUND'
        .catch (err) ->
          sendErr err, res

  app.route '/api/users'
    .post (req, res) ->
      createUser req.body
        .then (user) ->
          res
            .status 201
            .json user
        .catch (err) ->
          sendErr err, res

    .get (req, res)->
      getUsers()
        .then (users)->
          res
            .status 200
            .send users
        .catch (e)->
          sendErr e, res
