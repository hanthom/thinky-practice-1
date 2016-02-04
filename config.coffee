tunnel = require 'tunnel-ssh'
q = require 'q'
{username, host, sshPort, dbPort, uiPort, ip} = require("#{__dirname}/secrets").compose
composeConfig = 
  username: process.env.COMPOSE_USER || username
  host: process.env.COMPOSE_HOST || host
  sshPort: process.env.COMPOSE_SSH_PORT || sshPort
  dbPort: process.env.COMPOSE_DB_PORT || dbPort
  uiPort: process.env.COMPOSE_UI_PORT || uiPort
  ip: process.env.COMPOSE_IP || ip
localConfig =
  key: require('fs').readFileSync '/Users/charlescantrell/.ssh/id_rsa'
  ip: '127.0.0.1'
  dbPort: 27000
  uiPort: 8888

module.exports =
  localConfig: localConfig
  composeConfig: composeConfig
