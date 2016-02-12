{getDb} = require '../config/config'
{type, r} = getDb()
Todo = db.createModel 'Todo',
  text: type.string()
  createdAt: type.date().default r.now
  status: type.string().default('new').enum ['new', 'inProgress', 'complete']

Todo.ensureIndex 'createdAt'

module.exports = Todo