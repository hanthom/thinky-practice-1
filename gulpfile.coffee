gulp = require 'gulp'
{coffee, coffeelint, nodemon, tunnel, move, paths, watch} = require "#{__dirname}/config/tasks"

paths =
  sslCert: 'src/server-assets/config/sslCert.crt'
  server: 'build/server-assets/server.js'
  coffee:
    compile: "src/**/*.coffee"
    all: ["src/**/*.coffee", "!node_modules"]

gulp.task 'default', (cb)->
  runSquence = require 'run-sequence'
  process.env.NODE_ENV = 'development'
  runSquence 'coffeelint', ['coffee', 'move'], ['watch', 'nodemon'], cb

gulp.task 'coffeelint', ()->
  coffeelint paths.coffee.all

gulp.task 'coffee', ['coffeelint'], ()->
  coffee paths.coffee.compile, 'build'

gulp.task 'move', ()->
  move paths.sslCert, 'build/server-assets/config'

gulp.task 'nodemon', ()->
  nodemon paths.server
  
gulp.task 'watch', ()->
  watch paths.coffee.all, ['coffee']