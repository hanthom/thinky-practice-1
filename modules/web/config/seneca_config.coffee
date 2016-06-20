q = require 'q'
seneca = require('seneca')()
module.exports = (actionOpts, host)->
  client = seneca.client
    host: host
    port: 10101
  dfd = q.defer()
  client.act actionOpts, (err, res)->
    if err
      dfd.reject err
    else
      dfd.resolve res
  dfd.promise
