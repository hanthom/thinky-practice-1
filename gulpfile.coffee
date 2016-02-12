gulp = require 'gulp'
{coffee, coffeelint, nodemon, tunnel} = require "#{__dirname}/config/tasks"
paths =
  server: "#{__dirname}/build/server-assets/server.js"
  coffee:
    compile: ["#{__dirname}/src/**/*.coffee", "!#{__dirname}/src/config/secrets.coffee"]
    all: ["#{__dirname}/**/*.coffee,", "#{__dirname}/node_modules"]

gulp.task 'default', (cb)->
  runSquence = require 'run-sequence'
  process.env.NODE_ENV = 'development'
  runSquence 'coffeelint', 'coffee', ['watch', 'nodemon'], cb

gulp.task 'coffeelint', ()->
  coffeelint paths.coffee.all

gulp.task 'coffee', ['coffeelint'], ()->
  coffee paths.coffee.compile, './build'

gulp.task 'nodemon', ['tunnel'], ()->
  nodemon paths.server

gulp.task 'writeKey', ()->

gulp.task 'watch', ()->
  gulp.watch paths.coffee.all, ['coffee']