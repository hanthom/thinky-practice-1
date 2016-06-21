seneca = require 'seneca'
listener = seneca()
  .use './userCtrl'
  .ready (err)->
    client = seneca().client
      host: 'util'
      port: 10101
    if err
      args =
        role: 'util'
        cmd: 'handleErr'
        type: 'startup'
        err: err
      client
        .act args, (err)->
          if err then console.log 'UNABLE TO SEND ERR MSG'
          client.close()
    else
      listener.listen
        host: 'users'
        port: 10101
      args =
        role: 'util'
        cmd: 'log'
        service: 'user'
        message: 'User service started'
        type: 'general'
      client.act args, (err)->
        if err
          console.log 'UNABLE TO LOG STARTUP'
        client.close()
