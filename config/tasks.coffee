gulp = require 'gulp'

######
# All @params will be strings unless specified
######

##### addBase #####
# Adds the cwd to the path provided.
# Handles for the paths that ignore files
# @returns: string
addBase = (path)->
  base = "#{__dirname}/../#{path}"
  if path[0] is '!'
    path = path.slice 1, path.length - 1
    "!#{base}"
  else
    base

##### bundle #####
# Bundles using provided package and handles errs
# @params: bundler -> Browserify or Watchify package
bundle = (bundler, dest)->
  source = require 'vinyl-source-stream'
  dest = addBase dest
  bundler
    .bundle()
    .on 'error', (e)->
      console.log "ERROR WITH BUNDLING >>>> #{e.message}"
    .pipe source 'bundle.js'
    .pipe gulp.dest dest

##### fixPath #####
# Dynamically calls addBase fn with a src and dest
# @params: src -> string or array
# @returns: object
fixPath = (src, dest)->
  fixedPaths = {}
  if Array.isArray src
    # Handling for array type src
    fixedSrc = []
    fixedSrc.push addBase path for path in src
  else
    fixedSrc = addBase src
  if dest
    fixedDest = addBase dest
  fixedPaths =
    src: fixedSrc
    dest: fixedDest
  fixedPaths

######
# All @returns a .pipe to a gulp.dest unless specified
module.exports =
  ##### browserify #####
  # Creates initial bundle with browserify
  # Calls bundle with browserify as bundler
  browserify: (root, dest)->
    browserify = require 'browserify'
    bundle browserify(root), dest

  ##### coffee #####
  # Compiles coffeescript files to js
  coffee: (src, dest)->
    coffee = require 'gulp-coffee'
    {src, dest} = fixPath src, dest
    gulp.src src
      .pipe coffee()
      .on 'error', (e)->
        console.log "COFFEE ERROR >>>> #{e.message}"
        this.emit 'end'
      .pipe gulp.dest dest

  ##### coffeelint #####
  # Lints the coffeescript files specified
  # Prints the report in the console using 'stylish' reporter
  coffeelint: (src)->
    coffeelint = require 'gulp-coffeelint'
    stylishCoffee = require 'coffeelint-stylish'
    {src} = fixPath src
    gulp.src src
      .pipe coffeelint()
      .pipe coffeelint.reporter 'coffeelint-stylish'


  ##### jade #####
  # Compiles JADE into HTML
  # Uses 'prettify' to make HTML readable
  jade: (src, dest) ->
    prettify = require 'gulp-prettify'
    jade = require 'gulp-jade'
    {src, dest} = fixPath src, dest
    gulp.src src
      # prettify tossing error in html
      # .pipe prettify {indent_size: 2}
      .pipe jade()
      .pipe gulp.dest dest

  ##### move #####
  # Moves src files to dest path
  move: (src, dest)->
    {src, dest} = fixPath src, dest
    gulp.src src
      .pipe gulp.dest dest

  ##### nodemon #####
  # Runs nodemon with provided script
  # Delays restart by half second to handle for async tasks
  nodemon: (script)->
    nodemon = require 'gulp-nodemon'
    script = addBase script
    nodemon
      script: script
      delay: 250

  ##### prompt #####
  # Creates a command line prompt with given args
  # @params: questions -> object
  # @params: cb -> function
  prompt: (question, cb)->
    inquirer = require 'inquirer'
    inquirer.prompt question, cb

  ##### setEnv #####
  # Sets the environment with using .env.json
  # Overwrites or sets any other values given
  # @params: overWrites -> object
  setEnv: (path, overWrites)->
    gEnv = require 'gulp-env'
    gEnv
      file: path
      vars: overWrites

  ##### stylus #####
  # Compiles Stylus into css
  stylus: (src, dest) ->
    styl = require 'gulp-stylus'
    {src, dest} = fixPath src, dest
    gulp.src src
      .pipe styl()
      .pipe gulp.dest dest

  ##### test #####
  # Runs mocha tests with the options given
  # @params: opts -> object
  test: (src, reporter) ->
    ######
    # Needed to parse the env variable to get expected behavior
    ######
    if JSON.parse process.env.RUN_TESTS
      mocha = require 'gulp-mocha'
      opts =
        reporter: reporter
      gulp.src src
        .pipe mocha opts
        .on 'error', (err) ->
          console.log "MOCHA ERROR >>>> ", err.message
          @emit 'end'
    else
      console.log 'MOCHA >>>> TESTS TURNED OFF'
  ##### tunnel #####
  # Digs an SSH tunnel to Compose.io DB instance
  # @params: tunnelEnv -> object
  tunnel: ()->
    child = require 'child_process'
    child.exec "python #{__dirname}/tunnel.py"

  ##### watch #####
  # Watches the specified files for changes and runs the
  # @params: cb -> function
  watch: (path, cb)->
    {src} = fixPath path
    console.log "Should be watching #{src}"
    gulp.watch src, cb

  ##### watchify #####
  # Description
  # Creates watcher to update after changes in bundled js files
  # Calls bundle with watchify as bundler
  watchify: (root, dest)->
    watchify = require 'watchify'
    browserify = require 'browserify'
    watcher = watchify browserify(root), watchify.args
    bundle watcher, dest
    watcher
      .on 'update', ()->
        console.log 'Watchify Updating...'
        bundle watcher, dest
      .on 'log', (log)->
        console.log 'Watchify Log:'
        console.log log
