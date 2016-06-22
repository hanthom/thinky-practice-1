seneca = require 'seneca'
listener = seneca()
  .use './dbCtrl'
  .ready (err)->
    client = seneca().client host: 'util', port: 10101
    client.ready ->
      if err
        args =
          role: 'util'
          cmd: 'handleErr'
          service: 'db'
          message: 'Error with starting seneca listener in db'
          err: err
        client.act args, (err)->
          client.close ->
            if err then console.log 'UNABLE TO SEND ERR MSG'
      else
        listener.listen host: 'db', port: 10101
        args =
          role: 'util'
          cmd: 'log'
          service: 'db'
          type: 'general'
          message: 'DB service started'
        client.act args, (err)->
          client.close ->
            if err then console.log 'UNABLE TO LOG STARTUP'
