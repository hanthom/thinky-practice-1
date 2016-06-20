seneca = require 'seneca'
config =
  host: 'util'
  port: 10101
listener = seneca()
  .use './util'
  .listen config
  .ready ->
    client = seneca().client config
    client
      .ready ->
        args =
          role: 'util'
          cmd: 'log'
          type: 'general'
          service: 'util'
          message: 'Util service started'
        client.act args, (err)->
          if err
            console.log 'UNABLE TO LOG STARTUP'
