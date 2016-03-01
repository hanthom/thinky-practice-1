gulp = require 'gulp'
runSequence = require 'run-sequence'
tasks = require "#{__dirname}/config/tasks"
{browserify, coffee, coffeelint, jade, nodemon} = tasks
{paths, setEnv, stylus, test, tunnel, watchify, watch} = tasks

######
# Place to store paths that will be used again
paths =
  bundle:
    root: 'build/client/js/app.js'
    dest: 'build/client'
  env: '.env.json'
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
    all: 'test/server/*.coffee'
    config: require('./test/config').mochaSetup

gulp.task 'default', (cb)->
  setEnv paths.env
  runSequence 'tunnel', ['jade', 'stylus', 'coffeelint','coffee']
    , 'browserify'
    , ['watchify', 'nodemon', 'test' , 'watch']
    , cb

gulp.task 'build-dev', (cb)->
  setEnv paths.env, NODE_ENV: "development"
  runSequence ['jade', 'stylus', 'coffee'], 'browserify', cb

gulp.task 'build-heroku-dev', (cb)->
  process.env.NODE_ENV = 'development'
  runSequence ['jade', 'stylus', 'coffee'], 'browserify', cb

gulp.task 'build-prod', (cb)->
  runSequence ['jade', 'stylus', 'coffee'], 'browserify', cb

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

gulp.task 'test', () ->
  test paths.test.src, {reporter: paths.test.config.reporter}

gulp.task 'tunnel', ()->
  setEnv paths.env, DB_NAME: "todo_app_LOCAL"
  tunnel()

gulp.task 'watch', ()->
  watch paths.coffee.all, ()->
    runSequence 'coffeelint', 'coffee', 'test'
  watch paths.jade.all, ['jade']
  watch paths.stylus.all, ['stylus']
  watch paths.test.src, ['test']

gulp.task 'watchify', () ->
  watchify './build/client/js/app.js', './build/client/'
