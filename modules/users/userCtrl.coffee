q = require 'q'
module.exports = (options)->
  plugin  = 'user'
  patterns =
    username:
      cmd: 'get'
      type: 'username'
    email:
      cmd: 'get'
      type: 'email'
    all:
      cmd: 'get'
      type: 'all'
  for pattern, val of patterns
    patterns[pattern].role = plugin
    patterns[pattern].model = 'User'

  @add patterns.get.username, getUserByUsername
  @add patterns.get.email, getUserByEmail
  @add patterns.get.all, getUsers


  _act = (actionOpts)=>
    dfd = q.defer()
    @act actionOpts, (err, res)->
      if err
        dfd.reject err
      else
        dfd.resolve res
    dfd.promise

  _checkAndTrim = (users, type, done, array)->
    if users.length != 0
      if !array then users = users[0]
      trimOpts =
        role: 'util'
        cmd:'trim'
        data: users
        trim: ['password', 'id']
      _act trimOpts
      .then (trimmed)->
        done null, trimmed
      .catch done
    else
      err =
        message: "No users found with #{type}"
        status: 404
      done err

  ##### getUserByUsername #####
  # Gathers information for unique user
  # @params: username -> string
  # @returns: promise
  getUserByUsername = (args, done) ->
    {username} = args
    if !username
      err =
        message: 'Provide a username'
        status: 400
      done err
    else
      readOpts =
        role: 'db'
        cmd: 'read'
        model: 'User'
        query:
          build: (model)->
            model.filter username: username
      _act readOpts
        .then (res)->
          _checkAndTrim res, "username: #{username}", done
        .catch done
    dfd.promise

  ##### getUserByEmail #####
  # Gets user by email
  # @params: string
  # @resolves: object
  getUserByEmail = (args, done)->
    if !email
      err =
        message: 'Provide an email'
        status: 400
      done err
    else
      getOpts =
        role: 'db'
        cmd: 'get'
        query:
          build: (model)->
            model.filter email: email
      _act getOpts
        .then (user)->
          _checkAndTrim user, "email: #{email}", done
        .catch done

  ##### getAllUsers #####
  # Gather Information about User or Users
  # @params: filters -> object
  # @resolves: array
  getUsers = (args, done)->
    getOpts =
      role: 'db'
      cmd: 'get'
      model: 'user'
      filters: args.filters
    _act actionOpts
      .then (users)->
        _checkAndTrim users,
        "filters: #{JSON.stringify args.filters}", done, true
      .catch done
