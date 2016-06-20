seneca = require('seneca')()
seneca.client()
seneca.use './dbCtrl'
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
      service: 'user'
      type: 'startup'
    seneca
      .act args, (err)->
        if err
          console.log 'UNABLE TO LOG STARTUP'
