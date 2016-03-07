gulp = require 'gulp'
runSequence = require 'run-sequence'
tasks = require "#{__dirname}/config/tasks"
{browserify, coffee, coffeelint, jade, nodemon} = tasks
{prompt, setEnv, stylus, test, tunnel, watchify, watch} = tasks

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
  runSequence 'prompt'
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

gulp.task 'prompt', (done)->
  q1 =
    type: 'confirm'
    name: 'runTests'
    message:  'Do you want the tests to run on file saves?'
    default: 'false'
  q2 =
    type: 'confirm'
    name: 'watchDb'
    message: 'Do you want to watch the db?'
    default: 'false'
  q3 =
    type: 'confirm'
    name: 'watchServer'
    message: 'Do you want to watch the server?'
    default: 'false'
  prompt [q1, q2, q3], (answerObj)->
    setEnv paths.env,
      RUN_TESTS: answerObj.runTests
      WATCH_DB: answerObj.watchDb
      WATCH_SERVER: answerObj.watchServer
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
