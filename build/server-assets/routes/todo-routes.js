(function() {
  var addTodo, deleteTodo, editTodo, getAllTodos, getOneTodo, handleErr, todoCtrl;

  todoCtrl = require(__dirname + "/../controllers/todoCtrl");

  getOneTodo = todoCtrl.getOneTodo, getAllTodos = todoCtrl.getAllTodos, addTodo = todoCtrl.addTodo, editTodo = todoCtrl.editTodo, deleteTodo = todoCtrl.deleteTodo;

  handleErr = function(e, res) {
    return res.status(500).send(e);
  };

  module.exports = function(app) {
    app.get('/api/todos/:status', function(req, res) {
      return getAllTodos(req.params.status).then(function(todos) {
        if (todos.length >= 1) {
          return res.status(200).send(todos);
        } else {
          return res.status(404).send('NO TODOS FOUND');
        }
      })["catch"](function(e) {
        return handleErr(e, res);
      });
    });
    app.post('/api/todos', function(req, res) {
      return addTodo(req.body).then(function(todo) {
        return res.status(201).json(todo);
      })["catch"](function(e) {
        return handleErr(e, res);
      });
    });
    return app.route('/api/todos/:id').get(function(req, res) {
      return getOneTodo(req.params.id).then(function(todo) {
        if (todo) {
          return res.status(200).json(todo);
        } else {
          return res.status(404).send("NO TODO FOUND WITH ID: " + req.params.id);
        }
      })["catch"](function(e) {
        return handleErr(e, res);
      });
    }).patch(function(req, res) {
      return editTodo(req.params.id, req.body).then(function(todo) {
        return res.status(200).send(todo);
      })["catch"](function(e) {
        return handleErr(e, res);
      });
    })["delete"](function(req, res) {
      return deleteTodo(req.params.id).then(function() {
        return res.status(204).end();
      })["catch"](function(e) {
        return handleErr(e, res);
      });
    });
  };

}).call(this);
