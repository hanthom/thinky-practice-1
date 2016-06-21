express = require 'express'

app = express()

######
# Passes the app to the middleware and routes.
# These files export a function that expects the express app as an argument.
######
require("#{__dirname}/config/middleware") app
require("#{__dirname}/routes/todo_routes") app
require("#{__dirname}/routes/user_routes") app
require("#{__dirname}/routes/auth_routes") app

module.exports = app
