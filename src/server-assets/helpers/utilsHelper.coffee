module.exports =
  ##### handleErr #####
  # Creates a log message and rejects promise with log
  # @params: action -> string
  # @params: message -> string
  # @params: promise -> q.defer object
  handleErr: (action, message, promise)->
    log = "ERROR #{action} >>>> #{message}"
    console.log log
    promise.reject log

  ##### sendErr #####
  # Description
  # @params: repsonse -> Express response object
  # @params: error -> object
  sendErr: (repsonse, error)->
    console.log 'CALLED'
    status = error.status || 500
    err = error.msg || error
    console.log 'err', err
    console.log 'status', status
    response
      .status status
      .send err

  ##### watchModelFeed #####
  # Watches a model table for changes and handles with cb if provided
  # @params: model -> Thinky model
  # @params: cb -> function
  watchModelFeed: (model, cb)->
    model
      .changes()
      .then (feed)->
        if !cb
          feed.each (e, doc)->
            if e
              console.log 'ERROR WATCHING CHANGES >>>>', e
            else
              console.log "#{model} TABLE CHANGE >>>> ", doc
        else
          cb feed

  ##### trimResponse #####
  # Trims passed keys from response object
  # @params: res -> obj
  # @params: arr -> array
  # @returns: obj
  trimResponse: (res, arr)->
    if !res then return console.log "NO RESPONSE PASSED TO trimResponse"
    if !arr then return console.log "NO ARRAY PASSED TO trimResponse"
    for key in res
      for val in arr
        if res[key][val] then delete res[key][val]
    res
