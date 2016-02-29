gulp = require 'gulp'
runSquence = require 'run-sequence'
tasks = require "#{__dirname}/config/tasks"
{browserify, coffee, coffeelint, jade, nodemon, paths, stylus, test, watchify, watch} = tasks

######
# Place to store paths that will be used again
paths =
  bundle:
    root: 'build/client/js/app.js'
    dest: 'build/client'
  jade:
    compile: 'src/**/*.jade'
    all: ['src/**/*.jade']
  server: 'build/server-assets/server.js'
  stylus:
    compile: 'src/**/**/*.styl'
    all: ['src/**/**/*.styl']
  coffee:
    compile: 'src/**/*.coffee'
    all: ['src/**/*.coffee']
  test:
    src: 'test/server/**/*.coffee'
    config: require('./test/config').mochaSetup

gulp.task 'default', (cb)->
  # Sets env and ensures proper sequence of tasks

  process.env.NODE_ENV = 'development'
  runSquence ['jade', 'stylus', 'coffeelint','coffee']
    , 'browserify'
    , 'tests'
    , ['watchify'
    , 'nodemon'
    , 'watch']
    , cb

gulp.task 'build', (cb)->
  runSquence ['jade', 'stylus', 'coffee'], 'browserify', cb

gulp.task 'browserify', () ->
  browserify paths.bundle.root, paths.bundle.dest

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

gulp.task 'tests', () ->
  test paths.test.src, paths.test.config

gulp.task 'watch', ()->
  watch paths.coffee.all, ['coffeelint','coffee']
  watch paths.jade.all, ['jade']
  watch paths.stylus.all, ['stylus']

gulp.task 'watchify', () ->
  watchify './build/client/js/app.js', './build/client/'
