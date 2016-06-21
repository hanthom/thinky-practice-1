q = require 'q'

module.exports = (options)->
  plugin  = 'util'
  patterns =
    handleErr:
      missing_args:
        cmd: 'handleErr'
        type: 'missing_args'
        # name: <calling fn's name>
        # given: [
        #   {
        #     name: <var name>
        #     value: <given value>
        #   }
        # ]
      general:
        cmd: 'handleErr'
        type: 'general'
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

  _act = (actionOpts)=>
    console.log 'ACTION IN UTIL', actionOpts
    dfd = q.defer()
    @act actionOpts, (err, res)->
      if err
        dfd.reject err
      else
        if res.err
          dfd.reject res.err
        else
          dfd.resolve res.data
    dfd.promise

  _error = (done, message, status)->
    (err)->
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        service: 'util'
        message: message
        status: status or err.status
        err: err
      _act errOpts
      done null, err: errOpts

  _wrapMessage = (type, message, service)->
    title = "*_*_* #{type} from #{service.toUpperCase()} *_*_*\n"
    header = for char in title
      '='
    """
    #{header.join ''}
    #{title}
    #{message}\n
    _*_*_*_*_ END _*_*_*_*_
    =======================
    """

  ##### handleErr #####
  # Creates a log message and rejects promise with log
  # @params: action -> string
  # @params: message -> string
  # @params: promise -> q.defer object
  handleErr =
    general: (args, done)->
      {message, err, service, status} = args
      if status
        message = """
        #{message}\n
        -- Status --
        #{status}\n
        """
      if err
        message = """
        #{message}
        -- Error Object --
        #{JSON.stringify err}
        """
      message = _wrapMessage 'Error', message, service
      console.log message
      done null, data: 'Error logged.'
    missing_args: (args, done)->
      {name, given, service} = args
      base = """
      Missing Arguement Error
      -- Service: #{service}
      -- Function: #{name}
      """
      builtMessage = base
      for arg in given
        {name, value} = arg
        builtMessage = """#{builtMessage}\n
        - Arguement Set -
        Argument Name --> #{name}
        Given Value --> #{value}
        -----------------"""
      message = _wrapMessage 'Error', builtMessage, service
      console.log message
      done null, data:
        message: message
        status: 400
  log = (args, done)->
    {message, service} = args
    if !service or !message
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        type: 'missing_args'
        given:[
          {name: 'service'
          value: service},
          {name: 'message'
          value: message}
        ]
        message: err.message
        status: err.status
        service: 'util'
      _act errOpts
    else
      console.log _wrapMessage 'LOG', message, service
      done null, data: 'Message logged.'

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
      done null, data: trimmed

  for pattern, val of patterns
    if !val.cmd
      for subPattern, subVal of val
        patterns[pattern][subPattern].role = plugin
    else
      patterns[pattern].role = plugin

  @add patterns.handleErr.general, handleErr.general
  @add patterns.handleErr.missing_args, handleErr.missing_args
  @add patterns.log, log
  @add patterns.trim, trimResponse
