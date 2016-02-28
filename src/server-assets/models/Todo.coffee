db = require "#{__dirname}/../config/dbConfig"
{type, r} = db
#---------#
# Creates Todo model with given object
Todo = db.createModel 'Todo',
  text: type.string()
  createdAt: type.date().default r.now
  status: type.string().default('new').enum ['new', 'inProgress', 'complete']

#---------#
# Ensures controller can order by createdAt later
Todo.ensureIndex 'createdAt'

module.exports = Todo
