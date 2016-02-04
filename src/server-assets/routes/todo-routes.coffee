{getOneTodo, getAllTodos, addTodo, editTodo, deleteTodo} = require '../controllers/todoCtrl'

handleErr = (e, res)->
  res
    .status 500
    .send e

module.exports = (app)->

  app.get '/api/todos/:status', (req, res)->
    getAllTodos req.params.status
      .then (todos)->
        if todos
          res
            .status 200
            .send todos
        else
          res
            .status 404
            .send 'NO TODOS FOUND'
      .catch (e)->
        handleErr e, res

  app.post '/api/todo', (req, res)->
    addTodo req.body
      .then (todo)->
        res
          .status 201
          .json todo
      .catch (e)->
        handleErr e, res

  app.route '/api/todo/:id'
    .get (req, res)->
      getOneTodo req.params.id
        .then (todo)->
          if todo
            res
              .status 200
              .json todo
          else
            res
              .status 404
              .send "NO TODO FOUND WITH ID: #{req.params.id}"
        .catch (e)->
          handleErr e, res

    .patch (req, res)->
      editTodo req.params.id, req.body
        .then (todo)->
          res
            .status 200
            .send todo
        .catch (e)->
          handleErr e, res

    .delete (req, res)->
      deleteTodo req.params.id
        .then ()->
          res
            .status 204
            .end()
        .catch (e)->
          handleErr e, res