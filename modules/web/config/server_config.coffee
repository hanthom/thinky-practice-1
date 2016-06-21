_ = require 'lodash'
module.exports =
  logger: (req, res, next)->
    console.log "#{req.method} request to >>>> #{req.originalUrl}"
    if !_.isEmpty req.body
      console.log 'REQ BODY >>>>', req.body
    if !_.isEmpty req.params
      console.log 'REQ PARAMETERS >>>>', req.params
    next()
  port: process.env.PORT || process.env.EXPRESS_PORT || 9999
  sendErr: (res)->
    (err)->
      status = err.status or 500
      res
        .status status
        .send err
