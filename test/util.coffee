q = require 'q'
path = "#{__dirname}/../build/"
{db} = require "#{path}server-assets/config/dbConfig"
{r} = db
module.exports =
  app: require "#{path}server-assets/server"
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
        .then ->
          dfd.resolve()
      dfd.promise
    r: r

  pristineUser: ->
    faker = require 'faker'
    newUser =
      password: 'test'
      test: true
      username: faker.name.firstName()
