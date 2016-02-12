gulp = require 'gulp'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
stylishCoffee = require 'coffeelint-stylish'
nodemon = require 'gulp-nodemon'

module.exports =
  coffee: (src, dest)->
    gulp.src src
      .pipe coffee()
      .on 'error', (e)->
        console.log "COFFEE ERROR >>>> #{e.message}"
        this.emit 'end'
      .pipe gulp.dest dest
  coffeelint: (src)->
    gulp.src src
      .pipe coffeelint()
      .pipe coffeelint.reporter stylishCoffee
  move: (src, dest)->
    gulp.src src
      .pipe gulp.dest dest
  nodemon: (script)->
    console.log "ENV IN GULP >>>>  #{process.env.NODE_ENV}"
    nodemon
      script: script
      delay: 500
