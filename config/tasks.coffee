gulp = require 'gulp'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
stylishCoffee = require 'coffeelint-stylish'
nodemon = require 'gulp-nodemon'
pyShell = require 'python-shell'

addBase = (end)->
  base = "#{__dirname}/../#{end}"
  if end[0] is '!'
    end = end.slice 1, end.length - 1
    "!#{base}"
  else
    base
    
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