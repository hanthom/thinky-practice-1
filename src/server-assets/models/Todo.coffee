db = require "#{__dirname}/../config/dbConfig"
{type, r} = db
Todo = db.createModel 'Todo',
  text: type.string()
  createdAt: type.date().default r.now
  status: type.string().default('new').enum ['new', 'inProgress', 'complete']

Todo.ensureIndex 'createdAt'

module.exports = Todo
