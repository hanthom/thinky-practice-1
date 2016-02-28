gulp = require 'gulp'
tasks = require "#{__dirname}/config/tasks"
{coffee, coffeelint, jade, nodemon, paths, stylus, watch} = tasks

# Place to store paths that will be used again
paths =
  jade:
    compile: 'src/**/*.jade'
    all: ['src/**/*.jade']
  server: 'build/server-assets/server.js'
  stylus:
    compile: 'src/**/**/*.styl'
    all: ['src/**/**/*.styl']
  coffee:
    compile: "src/**/*.coffee"
    all: ["src/**/*.coffee"]

gulp.task 'default', (cb)->
  # Sets env and ensures proper sequence of tasks
  runSquence = require 'run-sequence'
  process.env.NODE_ENV = 'development'
  runSquence ['jade', 'stylus', 'coffeelint','coffee'], ['watch'], cb

gulp.task 'build', ['coffee']

gulp.task 'coffeelint', ()->
  coffeelint paths.coffee.compile

gulp.task 'coffee', ()->
  coffee paths.coffee.compile, 'build'

gulp.task 'jade', () ->
  jade paths.jade.compile, 'build'

gulp.task 'nodemon', ()->
  nodemon paths.server

gulp.task 'stylus', () ->
  stylus paths.stylus.compile, 'build'

gulp.task 'watch', ()->
  watch paths.coffee.all, ['coffeelint','coffee']
  watch paths.jade.all, ['jade']
  watch paths.stylus.all, ['stylus']
