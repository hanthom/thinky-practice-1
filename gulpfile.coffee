gulp = require 'gulp'
paths =
  server: './src/server-assets/server.coffee'
  coffee:
    compile: ['./src/**/*.coffee', '!./src/config/secrets.coffee']
    all: './**/*.coffee'

gulp.task 'default', (cb)->
  runSquence = require 'run-sequence'
  process.env.NODE_ENV = 'development'
  runSquence 'coffeelint', 'coffee', ['watch', 'nodemon'], cb

gulp.task 'coffeelint', ()->
  coffeelint = require 'gulp-coffeelint'
  stylishCoffee = require 'coffeelint-stylish'
  gulp.src paths.coffee.all
    .pipe coffeelint()
    .pipe coffeelint.reporter stylishCoffee


gulp.task 'coffee', ['coffeelint'], ()->
  coffee = require 'gulp-coffee'
  gulp.src paths.coffee.compile
    .pipe coffee()
    .on 'error', (e)->
      console.log "COFFEE ERROR >>>> #{e.message}"
      this.emit 'end'
    .pipe gulp.dest './build'

gulp.task 'tunnel', ()->
  {createTunnels, localConfig, composeConfig} = require './config'
  createTunnels localConfig, composeConfig
    .then ()->
      console.log 'Tunnels created!'
    .catch (e)->
      console.log 'Tunnel failure', e


gulp.task 'nodemon', ()->
  nodemon = require 'gulp-nodemon'
  console.log "ENV IN GULP >>>>  #{process.env.NODE_ENV}"
  nodemon
    script: paths.server
    delay: 500

gulp.task 'watch', ()->
  gulp.watch paths.coffee.all, ['coffee']