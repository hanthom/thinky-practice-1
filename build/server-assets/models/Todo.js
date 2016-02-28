(function() {
  var Todo, db, r, type;

  db = require(__dirname + "/../config/dbConfig");

  type = db.type, r = db.r;

  Todo = db.createModel('Todo', {
    text: type.string(),
    createdAt: type.date()["default"](r.now),
    status: type.string()["default"]('new')["enum"](['new', 'inProgress', 'complete'])
  });

  Todo.ensureIndex('createdAt');

  module.exports = Todo;

}).call(this);
