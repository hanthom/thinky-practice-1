######
# Calls appropriate controller methods with required arguements
# Handles resolves and handleErr calls
act = require "#{__dirname}/../config/seneca_config"
{sendErr} = require "#{__dirname}/../config/server_config"
module.exports = (app)->

  app.get '/api/todos/:status', (req, res)->
    getOpts =
      role: 'todo'
      cmd: 'get_many'
      status: req.params.status
    act getOpts, 'todo'
    .then (todos)->
      res
        .status 200
        .send todos
    .catch sendErr res

  app.route '/api/todos'
    .post (req, res)->
      postOpts =
        role: 'todo'
        cmd: 'addTodo'
        todo: req.body
      act postOpts, 'todo'
      .then (todo)->
        res
          .status 201
          .send todo
      .catch sendErr res

  app.route '/api/todo/:id'
    .get (req, res)->
      getOpts =
        role: 'todo'
        cmd: 'get_one'
        id: req.params.id
      act getOpts, 'todo'
      .then (todo)->
        res
          .status 200
          .send todo
      .catch sendErr res

    .patch (req, res)->
      patchOpts =
        role: 'todo'
        cmd: 'updateTodo'
        id: req.params.id
        changes: req.body
      act patchOpts, 'todo'
      .then (todo)->
        res
          .status 200
          .send todo
      .catch sendErr res

    .delete (req, res)->
      deleteOpts =
        role: 'todo'
        cmd: 'delete'
        id: req.params.id
      act deleteOpts, 'todo'
      .then ->
        res
          .status 204
          .end()
      .catch sendErr res
