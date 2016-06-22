q = require 'q'
seneca = require 'seneca'
_clients = {}
module.exports = (actionOpts, host)->
  dfd = q.defer()
  client = null
  if !_clients[host]
    client = seneca().client
      host: host
      port: 10101
    _clients[host] = client
  else
    client = _clients[host]
  client.ready ->
    client.act actionOpts, (err, res)->
      if err
        dfd.reject err
      else
        if res.err
          dfd.reject res.err
        else
          dfd.resolve res.data
  dfd.promise
