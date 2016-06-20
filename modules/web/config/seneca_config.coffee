q = require 'q'
seneca = require 'seneca'
module.exports = (actionOpts, host)->
  dfd = q.defer()
  client = seneca().client
    host: host
    port: 10101
  client.ready ->
    client.act actionOpts, (err, res)->
      if err
        dfd.reject err
      else
        dfd.resolve res
  dfd.promise
