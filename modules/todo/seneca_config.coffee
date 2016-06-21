seneca = require 'seneca'
listener = seneca()
  .use './todoCtrl'
  .ready (err)->
    client = seneca().client host: 'util', port: 10101
    client.ready ->
      if err
        args =
          role: 'util'
          cmd: 'handleErr'
          service: 'todo'
          message: 'Error with starting seneca listener in todo'
          err: err
        client
          .act args, (err)->
            if err then console.log 'UNABLE TO SEND ERR MSG'
      else
        listener.listen host: 'todo', port: 10101
        args =
          role: 'util'
          cmd: 'log'
          service: 'todo'
          type: 'general'
          message: 'Todo service started'
        client
          .act args, (err)->
            if err
              console.log 'UNABLE TO LOG STARTUP'
