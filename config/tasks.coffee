gulp = require 'gulp'

# Accepts a path from the gulpfile and accounts for this file location
# Checks to see if path is for ignore and adds !
# Returns full path (string)
addBase = (path)->

  base = "#{__dirname}/../#{path}"
  if path[0] is '!'
    path = path.slice 1, path.length - 1
    "!#{base}"
  else
    base
# Accepts a bundler package and destination path
# Bundles using provided package and handles errs
# Writes a 'bundle.js' file to dest
bundle = (bundler, dest)->
  source = require 'vinyl-source-stream'
  dest = addBase dest
  console.log __dirname
  bundler
    .bundle()
    .on 'error', (e)->
      console.log "ERROR WITH BUNDLING >>>> #{e.message}"
    .pipe source 'bundle.js'
    .pipe gulp.dest dest

# Accepts srting src and dest
# Dynamically calls addBase fn with a src and dest
# Returns an object with src, dest keys
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

module.exports =
  # Accepts a string destination
  # Creates initial bundle with browserify
  # Calls bundle with browserify as bundler
  browserify: (dest)->
    browserify = require 'browserify'
    bundle browserify(), dest

  # Accepts string src and dest
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

  # Accepts string src
  # Lints coffee files
  # Logs reports with stylish coffee package
  coffeelint: (src)->
    coffeelint = require 'gulp-coffeelint'
    stylishCoffee = require 'coffeelint-stylish'
    {src} = fixPath src
    gulp.src src
      .pipe coffeelint()
      .pipe coffeelint.reporter stylishCoffee

  # Compiles JADE into HTML
  # @param string
  # @param string
  jade: (src, dest) ->
    prettify = require 'gulp-prettify'
    jade = require 'gulp-jade'
    {src, dest} = fixPath src, dest
    gulp.src src
      # prettify tossing error in html
      # .pipe prettify {indent_size: 2}
      .pipe jade()
      .pipe gulp.dest dest

  # Accepts string src and dest
  # Moves src files to dest path
  move: (src, dest)->
    {src, dest} = fixPath src, dest
    gulp.src src
      .pipe gulp.dest dest

  # Accepts string script
  # Runs nodemon with provided script
  # Delays restart by hald second to handle for async tasks
  nodemon: (script)->
    nodemon = require 'gulp-nodemon'
    script = addBase script
    console.log "ENV IN GULP >>>> #{process.env.NODE_ENV}"
    nodemon
      script: script
      delay: 500

  # Compiles Stylus into css
  # @param string
  # @param string
  stylus: (src, dest) ->
    styl = require 'gulp-stylus'

    {src, dest} = fixPath src, dest
    gulp.src src
      .pipe styl()
      .pipe gulp.dest dest

  # Accepts string path
  # Tasks is an array of string task names
  # Watches for changes in files and runs tasks on save
  watch: (path, tasks)->
    {src} = fixPath path
    console.log "Should be watching #{src}"
    gulp.watch src, tasks

  # Accepts string dest to write updated bundle.js
  # Creates watcher to update after changes in bundled js files
  # Calls bundle with watchify as bundler
  watchify: (watch, dest)->
    watchify = require 'watchify'
    browserify = require 'browserify'
    watcher = watchify browserify(watch), watchify.args
    bundle watcher, dest
    watcher
      .on 'update', ()->
        console.log 'Watchify Updating...'
        bundle watcher
      .on 'log', (log)->
        console.log 'Watchify Log:'
        console.log log
