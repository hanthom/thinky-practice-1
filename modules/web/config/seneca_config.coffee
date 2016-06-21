q = require 'q'
module.exports = (actionOpts, host)->
  seneca = require('seneca')()
  dfd = q.defer()
  client = seneca.client
    host: host
    port: 10101
  client.ready ->
    client.act actionOpts, (err, res)->
      client.close ->
        if err
          dfd.reject err
        else
          if res.err
            dfd.reject res.err
          else
            dfd.resolve res.data
  dfd.promise
