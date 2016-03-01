userCtrl = require "#{__dirname}/../controllers/userCtrl"
{createUser, getOneUser, getUsers, updateUser, deleteUser} = userCtrl

handleErr = (e, res)->
  res
    .status 500
    .send e

module.exports = (app) ->
  app.get '/api/users/:username', (req, res) ->
    getUsers req.params.username
      .then (users) ->
        if users.length >= 1
          res
            .status 200
            .send users
        else
          res
            .status 404
            .send 'NO USERS FOUND'
      .catch (err) ->
        handleErr err, res
  app.post '/api/users', (req, res) ->
    createUser req.body
      .then (user) ->
        res
          .status 201
          .json user
      .catch (err) ->
        handleErr err, res
