gulp = require 'gulp'
runSequence = require 'run-sequence'
tasks = require "#{__dirname}/config/tasks"
{browserify, coffee, coffeelint, jade, nodemon} = tasks
{setEnv, setup, stylus, test, tunnel, watchify, watch} = tasks

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
    src: 'test/**/*.coffee'
    all: 'test/server/*.coffee'
    controllers: 'test/server/controllers/*.coffee'

gulp.task 'default', (cb)->
  runSequence 'setup'
    , ['tunnel', 'build',]
    , ['watchify', 'nodemon', 'watch']
    , 'test'
    , cb

gulp.task 'build-dev', (cb)->
  setEnv paths.env, NODE_ENV: "development"

gulp.task 'build', (cb)->
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
    .on 'start', ()->
      runSequence 'test'

gulp.task 'setup', (done)->
  setup (answerObj)->
    overwrites = {}
    for task in answerObj.helpers
      switch task
        when 'DB' then overwrites.WATCH_DB = true
        when 'Server' then overwrites.WATCH_SERVER = true
        when 'Test' then overwrites.RUN_TESTS = true
    setEnv paths.env, overwrites
    done()

gulp.task 'stylus', () ->
  stylus paths.stylus.compile, 'build'

gulp.task 'test', () ->
  test paths.test.src, 'nyan'

gulp.task 'tunnel', ()->
  setEnv paths.env
  tunnel()

gulp.task 'watch', ()->
  watch paths.coffee.all, ()->
    runSequence 'coffeelint', 'coffee'
  watch paths.jade.all, ['jade']
  watch paths.stylus.all, ['stylus']
  watch paths.test.src, ['test']

gulp.task 'watchify', () ->
  watchify './build/client/js/app.js', './build/client/'
