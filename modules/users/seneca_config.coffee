seneca = require('seneca')()
seneca.use './userCtrl'
seneca.client()
seneca.ready (err)->
  if err
    args =
      role: 'util'
      cmd: 'handleErr'
      type: 'startup'
      err: err
    seneca
      .act args, (err)->
        if err then console.log 'UNABLE TO SEND ERR MSG'
  else
    args =
      role: 'util'
      cmd: 'log'
      message: 'User'
      type: 'startup'
    seneca
      .act args, (err)->
        if err
          console.log 'UNABLE TO LOG STARTUP'
    seneca.listen
      host: 'web'
    seneca.listen
      host: 'auth'
