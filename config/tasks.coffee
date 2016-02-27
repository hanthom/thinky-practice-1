gulp = require 'gulp'

addBase = (path)->
  # Accepts a path from the gulpfile and accounts for this file location
  # Checks to see if path is for ignore and adds !
  # Returns full path (string)
  base = "#{__dirname}/../#{path}"
  if path[0] is '!'
    path = path.slice 1, path.length - 1
    "!#{base}"
  else
    base

bundle = (bundler, dest)->
  # Accepts a bundler package and destination path
  # Bundles using provided package and handles errs
  # Writes a 'bundle.js' file to dest
  source = require 'vinyl-source-stream'
  dest = addBase dest
  bundler
    .bundle()
    .on 'error', (e)->
      console.log "ERROR WITH BUNDLING >>>> #{e.message}"
    .pipe source 'bundle.js'
    .pipe gulp.dest dest

fixPath = (src, dest)->
  # Accepts srting src and dest
  # Dynamically calls addBase fn with a src and dest
  # Returns an object with src, dest keys
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


module.exports =
  browserify: (dest)->
    # Accepts a string destination
    # Creates initial bundle with browserify
    # Calls bundle with browserify as bundler
    browserify = require 'browserify'
    bundle browserify, dest

  coffee: (src, dest)->
    # Accepts string src and dest
    # Compiles coffeescript files to js
    coffee = require 'gulp-coffee'
    {src, dest} = fixPath src, dest
    gulp.src src
      .pipe coffee()
      .on 'error', (e)->
        console.log "COFFEE ERROR >>>> #{e.message}"
        this.emit 'end'
      .pipe gulp.dest dest

  coffeelint: (src)->
    # Accepts string src
    # Lints coffee files
    # Logs reports with stylish coffee package
    coffeelint = require 'gulp-coffeelint'
    stylishCoffee = require 'coffeelint-stylish'
    {src} = fixPath src
    gulp.src src
      .pipe coffeelint()
      .pipe coffeelint.reporter stylishCoffee

  move: (src, dest)->
    # Accepts string src and dest
    # Moves src files to dest path
    {src, dest} = fixPath src, dest
    gulp.src src
      .pipe gulp.dest dest

  nodemon: (script)->
    # Accepts string script
    # Runs nodemon with provided script
    # Delays restart by hald second to handle for async tasks
    nodemon = require 'gulp-nodemon'
    script = addBase script
    console.log "ENV IN GULP >>>> #{process.env.NODE_ENV}"
    nodemon
      script: script
      delay: 500

  watch: (path, tasks)->
    # Accepts string path
    # Tasks is an array of string task names
    # Watches for changes in files and runs tasks on save
    {src} = fixPath path
    console.log "Should be watching #{src}"
    gulp.watch src, tasks

  watchify: (dest)->
    # Accepts string dest to write updated bundle.js
    # Creates watcher to update after changes in bundled js files
    # Calls bundle with watchify as bundler
    watchify = require 'watchify'
    dest = addBase dest
    watcher = watchify browserify(dest), watchify.args
    bundle watcher, dest
    watcher
      .on 'update', ()->
        console.log 'Watchify Updating...'
        bundle watcher
      .on 'log', (log)->
        console.log 'Watchify Log:'
        console.log log
