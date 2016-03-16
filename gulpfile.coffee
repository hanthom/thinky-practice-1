gulp = require 'gulp'
runSequence = require 'run-sequence'
tasks = require "#{__dirname}/config/tasks"
{browserify, coffee, coffeelint, jade, nodemon} = tasks
{setEnv, setup, serverRunner, stylus, test, tunnel, watchify, watch} = tasks

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
    src: []
    all: 'test/server/*.coffee'
    controllers:
      todo: 'test/server/controllers/todoCtrl-t.coffee'
      user: 'test/server/controllers/userCtrl-t.coffee'
    routes:
      auth: 'test/server/routes/authRoutes-t.coffee'
      todo: 'test/server/routes/todoRoutes-t.coffee'
      user: 'test/server/routes/userRoutes-t.coffee'
    helpers:
      crud: 'test/server/helpers/crudHelper-t.coffee'

gulp.task 'default', (cb)->
  runSequence 'setup'
    , ['tunnel', 'build']
    , 'server'
    , ['watchify', 'watch']
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

gulp.task 'setup', (done)->

  setup (answerObj)->
    overwrites = {}
    if answerObj.tests.length
      for task in answerObj.watchers
        switch task
          when 'DB' then overwrites.WATCH_DB = true
          when 'Server' then overwrites.WATCH_SERVER = true
          when 'Test' then overwrites.RUN_TESTS = true
    if answerObj.tests.length
      ######
      # Only turn tests on if files are selected
      ######
      overwrites.RUN_TESTS = true
      tests = paths.test.src
      ######
      # Add only the files we want to test to the test src array
      ######
      for file in answerObj.tests
        switch file
          when 'userCtrl' then tests.push paths.test.controllers.user
          when 'todoCtrl' then tests.push paths.test.controllers.todo
          when 'userRoutes' then tests.push paths.test.routes.user
          when 'todoRoutes' then tests.push paths.test.routes.todo
          when 'authRoutes' then tests.push paths.test.routes.auth
          when 'crudHelper' then tests.push paths.test.helpers.crud
    setEnv paths.env, overwrites
    done()


gulp.task 'server', ->
  {listen, close} = serverRunner paths.server
  serv = listen 9229, ->
    console.log 'fired in gulp'

gulp.task 'stylus', ->
  stylus paths.stylus.compile, 'build'

gulp.task 'test', ->
  test paths.test.src, 'nyan'

gulp.task 'tunnel', ->
  ######
  # This gets called after setup task has run.
  # Will need to accomodate for potential overwites due to 'setEnv'
  # getting called twice
  ######
  setEnv paths.env
  tunnel()

gulp.task 'watch', ->
  watch paths.coffee.all, ()->
    runSequence 'coffeelint', 'coffee'
  watch paths.jade.all, ['jade']
  watch paths.stylus.all, ['stylus']
  watch paths.test.src, ['test']

gulp.task 'watchify', () ->
  watchify './build/client/js/app.js', './build/client/'
