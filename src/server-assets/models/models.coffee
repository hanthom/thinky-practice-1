# Collects all models in one place for relations
# Exports all models after relations have been made
Todo = require "#{__dirname}/Todo"
User = require "#{__dirname}/User"

User.hasMany Todo, 'todos', 'id', 'userId'
Todo.belongsTo User, 'user', 'userId', 'id'

module.exports =
  Todo: Todo
  User: User
