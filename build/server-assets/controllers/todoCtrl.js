(function() {
  var Todo, handleErr, q, r;

  Todo = require('../models/models').Todo;

  q = require('q');

  r = require(__dirname + "/../config/dbConfig").r;

  handleErr = function(action, message, promise) {
    var log;
    log = "ERROR " + action + " >>>> " + message;
    console.log(log);
    return promise.reject(log);
  };

  module.exports = {
    addTodo: function(todo) {
      var dfd;
      dfd = q.defer();
      new Todo(todo).save().then(function(doc) {
        console.log('TODO SAVED >>>>', doc);
        return dfd.resolve(doc);
      })["catch"](function(e) {
        return handleErr('SAVING TODO', e.message, dfd);
      });
      return dfd.promise;
    },
    getOneTodo: function(id) {
      var dfd;
      dfd = q.defer();
      Todo.get(id).run().then(function(todo) {
        console.log('TODO >>>>', todo);
        return dfd.resolve(todo);
      })["catch"](function(e) {
        return handleErr('GETTING TODO', e.message, dfd);
      });
      return dfd.promise;
    },
    getAllTodos: function(status) {
      var dfd, query;
      dfd = q.defer();
      query = Todo.orderBy({
        index: r.desc('createdAt')
      });
      if (status !== 'all') {
        query = query.filter({
          status: status
        });
      }
      query.run().then(function(todos) {
        console.log('TODOS >>>>', todos);
        return dfd.resolve(todos);
      })["catch"](function(e) {
        return handleErr('GETTING TODOS', e.message, dfd);
      });
      return dfd.promise;
    },
    editTodo: function(id, changes) {
      var dfd;
      dfd = q.defer();
      Todo.get(id).update(changes).run().then(function(result) {
        return dfd.resolve(result);
      })["catch"](function(e) {
        return handleErr('UPDATING TODO', e.message, dfd);
      });
      return dfd.promise;
    },
    deleteTodo: function(id) {
      var dfd;
      dfd = q.defer();
      Todo.get(id)["delete"]().run().then(function(result) {
        console.log("DELETED TODO " + id);
        return dfd.resolve();
      })["catch"](function(e) {
        return handleErr('DELETING TODO', e.message, dfd);
      });
      return dfd.promise;
    }
  };

}).call(this);
