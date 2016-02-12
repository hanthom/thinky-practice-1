tunnel = require 'tunnel-ssh'
Adit = require 'adit'
{localConfig, composeConfig} = require './config'
{username, sshPort, host} = composeConfig
{key, keyPath} = localConfig
console.log sshPort

uiConfig =
  privateKey: key
  username: username
  sshPort: sshPort
  host: host
  srcHost: composeConfig.ip
  srcPort: composeConfig.uiPort
  dstPort: localConfig.uiPort
  dstHost: localConfig.ip
  keepAlive: true

uiTunnel = tunnel uiConfig, (e, uiTunnel)->
  if e
    console.log 'TUNNEL ERROR >>>>', e.message
  else
    console.log 'UI TUNNEL >>>>', uiTunnel



module.exports =
  ui: uiTunnel