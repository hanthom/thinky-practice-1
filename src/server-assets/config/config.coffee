module.exports =
  server:
    logger: (req, res, next)->
      console.log "#{req.method} request to >>>> #{req.originalUrl}"
      if req.body is !{}
        console.log 'REQUEST BODY >>>>', req.body
      if req.params is !{}
        console.log 'REQUEST PARAMETERS >>>>', req.params
      next()
    port: 9999
  getDb: require("#{__dirname}/dbConfig").getDb
    