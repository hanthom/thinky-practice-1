module.exports =
  logger: (req, res, next)->
    console.log "#{req.method} request to >>>> #{req.originalUrl}"
    if req.body
      console.log 'REQUEST BODY >>>>', req.body
    if req.params is !{}
      console.log 'REQUEST PARAMETERS >>>>', req.params
    next()
  port: process.env.PORT || process.env.EXPRESS_PORT
