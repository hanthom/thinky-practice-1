seneca = require('seneca')()
config =
  host: 'util'
  port: 10101
listener = seneca
  .use './util'
  .ready ->
    listener.listen config
    client = seneca.client config
    client
      .ready ->
        args =
          role: 'util'
          cmd: 'log'
          type: 'general'
          service: 'util'
          message: 'Util service started'
        client.act args, (err, res)->
          if err
            console.log 'UNABLE TO LOG STARTUP'
