seneca = require('seneca')()
seneca.use './util'
home_client = seneca.client host: 'util', port: 10101
if false
  args =
    role: 'util'
    cmd: 'handleErr'
    err: err
  home_client
    .act args, (err)->
      if err then console.log 'UNABLE TO SEND ERR MSG'
else
  seneca
    .listen host: 'util', port: 10101
  args =
    role: 'util'
    cmd: 'log'
    type: 'general'
    service: 'util'
    message: 'Util service started'
  home_client.act args, (err)->
    if err
      console.log 'UNABLE TO LOG STARTUP'
  # .listen host: 'web', port: 10101
