faker = require 'faker'
q = require 'q'
src = "#{__dirname}/../src/server-assets/"
{db} = require "#{src}config/dbConfig"
{r} = db
module.exports =
  db:
    clean: (table)->
      dfd = q.defer()
      r.table table
        .filter test: true
        .delete()
        .then (res)->
          console.log 'DB cleaned'
          dfd.resolve()
      dfd.promise

    insertDoc: (model, insert)->
      dfd = q.defer()
      new model insert
        .save()
        .then ()->
          dfd.resolve()
      dfd.promise

    r: r
  pristineUser: ()->
    newUser =
      password: 'test'
      test: true
      username: faker.name.firstName()
