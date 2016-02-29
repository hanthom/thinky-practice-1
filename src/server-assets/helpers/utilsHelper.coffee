##### handleErr #####
# Creates a log message and rejects promise with log
# @params: action -> string
# @params: message -> string
# @params: promise -> q.defer object
module.exports =
  handleErr: (action, message, promise)->
    log = "ERROR #{action} >>>> #{message}"
    console.log log
    promise.reject log
