gulp = require 'gulp'
{coffee, coffeelint, nodemon, paths, watch, build} = require "#{__dirname}/config/tasks"

paths =
  server: 'build/app.js'
  coffee:
    compile: "src/**/*.coffee"
    all: ["src/**/*.coffee", "!node_modules"]

gulp.task 'default', (cb)->
  runSquence = require 'run-sequence'
  process.env.NODE_ENV = 'development'
  runSquence 'coffeelint',['coffee'],['nodemon','watch'], cb

gulp.task 'build', ['coffee']

gulp.task 'coffeelint', ()->
  coffeelint paths.coffee.all

gulp.task 'coffee', ['coffeelint'], ()->
  coffee paths.coffee.compile, 'build'

gulp.task 'nodemon', ()->
  nodemon paths.server
  
gulp.task 'watch', ()->
  watch paths.coffee.all, ['coffee']