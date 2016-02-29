module.exports =
  logger: (req, res, next)->
    console.log "#{req.method} request to >>>> #{req.originalUrl}"
    console.log "REQ BODY >>>>> ", req.body
    if req.body is !{}
      console.log 'REQUEST BODY >>>>', req.body
    if req.params is !{}
      console.log 'REQUEST PARAMETERS >>>>', req.params
    next()
  port: process.env.PORT || 9999
