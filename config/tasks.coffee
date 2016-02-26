browserify = require 'browserify'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
gulp = require 'gulp'
nodemon = require 'gulp-nodemon'
source = require 'vinyl-source-stream'
stylishCoffee = require 'coffeelint-stylish'
watchify = require 'watchify'

addBase = (end)->
  base = "#{__dirname}/../#{end}"
  if end[0] is '!'
    end = end.slice 1, end.length - 1
    "!#{base}"
  else
    base

bundle = (bundler, dest)->
  dest = addBase dest
  bundler
    .bundle()
    .on 'error', (e)->
      console.log "ERROR WITH BUNDLING >>>> #{e.message}"
    .pipe source 'bundle.js'
    .pipe gulp.dest dest

fixPath = (src, dest)->
  fixedPaths = {}
  if Array.isArray src
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
  browserify: (script)->
    script = addBase script
    bundle browserify script

  coffee: (src, dest)->
    {src, dest} = fixPath src, dest
    gulp.src src
      .pipe coffee()
      .on 'error', (e)->
        console.log "COFFEE ERROR >>>> #{e.message}"
        this.emit 'end'
      .pipe gulp.dest dest

  coffeelint: (src)->
    {src} = fixPath src
    gulp.src src
      .pipe coffeelint()
      .pipe coffeelint.reporter stylishCoffee

  move: (src, dest)->
    {src, dest} = fixPath src, dest
    gulp.src src
      .pipe gulp.dest dest

  nodemon: (script)->
    script = addBase script
    console.log "ENV IN GULP >>>> #{process.env.NODE_ENV}"
    nodemon
      script: script
      delay: 500

  watch: (path, tasks)->
    {src} = fixPath path
    console.log "Should be watching #{src}"
    gulp.watch src, tasks

  watchify: (script)->
    script = addBase script
    watcher = watchify browserify(script), watchify.args
    bundle watcher
    watcher
      .on 'update', ()->
        console.log 'Watchify Updating...'
        bundle watcher
      .on 'log', (log)->
        console.log 'Watchify Log:'
        console.log log
