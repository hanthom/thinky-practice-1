db = require "#{__dirname}/../config/dbConfig"
{type, r} = db

User = db.createModel 'User',
  email: type.string()
  username: type.string()
  password: type.string()
  createdAt: Date
  updatedAt: Date
  
