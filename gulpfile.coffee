gulp = require 'gulp'
tasks = require "#{__dirname}/config/tasks"
{coffee, coffeelint, nodemon, paths, watch} = tasks

# Place to store paths that will be used again
paths =
  server: 'build/server-assets/server.js'
  coffee:
    compile: "src/**/*.coffee"
    all: ["src/**/*.coffee", "!node_modules"]

gulp.task 'default', (cb)->
  # Sets env and ensures proper sequence of tasks
  runSquence = require 'run-sequence'
  process.env.NODE_ENV = 'development'
  runSquence 'coffeelint','coffee', ['nodemon','watch'], cb

gulp.task 'build', ['coffee']

gulp.task 'coffeelint', ()->
  coffeelint paths.coffee.all

gulp.task 'coffee', ()->
  coffee paths.coffee.compile, 'build'

gulp.task 'nodemon', ()->
  nodemon paths.server

gulp.task 'watch', ()->
  watch paths.coffee.all, ['coffeelint','coffee']
