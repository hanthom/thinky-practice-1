q = require 'q'
module.exports = (options)->
  plugin  = 'util'
  patterns =
    handleErr:
      cmd: 'handleErr'
      # message: string
      # service: string
      # [err: object]
      # [status: number or string]
    log:
      cmd: 'log'
      type: 'general'
      # message: string
      # service: string
    trim:
      cmd: 'trim'
  for pattern, val of patterns
    patterns[pattern].role = plugin

  @add patterns.handleErr, handleErr
  @add patterns.log, log
  @add patterns.trim, trimResponse

  _act = (actionOpts)=>
    dfd = q.defer()
    @act actionOpts, (err, res)->
      if err
        dfd.reject err
      else
        dfd.resolve res
    dfd.promise
  ##### handleErr #####
  # Creates a log message and rejects promise with log
  # @params: action -> string
  # @params: message -> string
  # @params: promise -> q.defer object
  handleErr = (args, done)->
    {message, err, service, status} = args
    message = "---- Error in #{service} service ----\n
    -- Message --\n
    #{message}
    -- Error Object --\n
    #{JSON.stringify err}"
    if status then message = "#{message}\n-- Status --\n--#{status}"
    console.log message
    done()

  log = (args, done)->
    {message, service} = args
    if !service or !message
      err =
        message: "Missing args 'message' or 'service'\n
        -- service: #{service}\n
        -- message: #{message}"
        status: 400
      done err
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        message: err.message
        status: err.status
        service: 'util'
      _act errOpts
    else
      console.log "Message from -- #{service}\n-- Message --\n#{message}"
      done()

  ##### trimResponse #####
  # Trims passed keys from response object
  # @params: object
  # @params: array
  # @returns: object
  trimResponse = (args, done) ->
    {toBeTrimmed, props} = args
    if !toBeTrimmed or !props
      err =
        message: "Missing args toBeTrimmed or props\n
        -- toBeTrimmed: #{toBeTrimmed}\n
        -- props: #{props}"
        status: 400
      done err
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        message: err.message
        status: err.status
        service: 'util'
      _act errOpts
    else
      trimmed = null
      trim = (obj)->
        for key, val of obj
          if props.indexOf(key) != -1
            delete obj[key]
        obj
      if Array.isArray toBeTrimmed
        trimmed = []
        for untrimmed in toBeTrimmed
          trimmed.push trim untrimmed
      else
        trimmed = trim obj
      done null, trimmed
