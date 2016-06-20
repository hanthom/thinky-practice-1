q = require 'q'
url = '/api/todo'
log = (str, res)->
  console.log "Result from #{str}", res
new class TodoService
  constructor: ($http)->
    @getTodos = (status)->
      console.log "Status coming into getTodos #{status}"
      if status then path = "#{url}s/#{status}"
      else path = "#{url}s"
      console.log path
      dfd = q.defer()
      $http
        .get path
        .then (r)->
          log "getting todos", r
          dfd.resolve r.data
      dfd.promise
    @getTodo = (id)->
      path = "#{url}/#{id}"
      dfd = q.defer()
      $http
        .get path
        .then (r)->
          log "getting todo with id: #{id}", r
          dfd.resolve r.data
      dfd.promise
    @addTodo = (todo)->
      dfd = q.defer()
      $http
        .post "#{url}s", todo
        .then (r)->
          log "posting #{todo}", r
          dfd.resolve()
      dfd.promise

module.exports = TodoService
