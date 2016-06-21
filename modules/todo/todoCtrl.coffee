q = require 'q'
module.exports = (options)->
  plugin = 'todo'
  patterns =
    addTodo:
      cmd: 'addTodo'
      # insert: object
    get:
      one:
        cmd: 'get'
        type: 'one'
        # id: string
      many:
        cmd: 'get'
        type: 'many'
        # status: string
    updateTodo:
      cmd: 'updateTodo'
      # id: string
      # changes: object
    deleteTodo:
      cmd: 'deleteTodo'
      # id: string

  _act = (actionOpts, host)->
    dfd = q.defer()
    client = require('seneca')()
      .client
        host: host
        port: 10101
    client.ready ->
      client.act actionOpts, (err, res)->
        client.close ->
          if err
            dfd.reject err
          else
            if res.err
              dfd.reject res.err
            else
              dfd.resolve res.data
    dfd.promise

  _error = (done, message, status)->
    handler = (err)->
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        type: 'general'
        service: 'todo'
        message: message
        status: status or err.status
        err: err
      _act errOpts, 'util'
      done null, err: errOpts
    handler

  addTodo = (args, done)->
    {insert} = args
    if !insert
      errOpts =
        role: 'util'
        cmd: 'handleErr'
        type: 'missing_args'
        service: 'todo'
        name: 'addTodo'
        given:[
          {name: 'insert'
          value: insert}
        ]
      _act errOpts, 'util'
      .then _error done, 'Missing Arguements', 400
    else
      addOptions =
        role: 'db'
        cmd: 'create'
        insert: insert
        model: 'Todo'
      _act addOptions, 'db'
      .then (todo)->
        done null, data: todo
      .catch (err)->
        handler = _error done, 'Inserting todo'
        handler(err)

  getOneTodo = (args, done)->
    getOptions =
      role: 'db'
      cmd: 'read'
      model: 'Todo'
      query:
        build: (Todo)->
          Todo.get args.id
    _act getOptions, 'db'
    .then (todo)->
      done null, data: todo
    .catch _error done, "Could not get todo with id: #{id}"

  getTodos = (args, done)->
    {status} = args
    getManyOptions =
      role: 'db'
      cmd: 'read'
      model: 'Todo'
      query:
        build: (Todo)->
          Todo.filter status: status
    _act getManyOptions, 'db'
    .then (todos)->
      done null, data: todos
    .catch _error done, "Could not get #{status} todos."

  updateTodo = (args, done)->
    {id, changes} = args
    updateOptions =
      role: 'db'
      model: 'Todo'
      id: id
      changes: changes
    _act updateOptions, 'db'
    .then (updatedTodo)->
      done null, data: updatedTodo
    .catch _error done, "Updating todo: #{id}"

  deleteTodo = (args, done)->
    deleteOptions =
      role: 'db'
      model: 'Todo'
      id: args.id
    _act deleteOptions, 'db'
    .then ->
      done null, message: "Removal completed for todo: #{id}"
    .catch _error done, "Removing todo: #{id}"

  for pattern, val of patterns
    if !val.cmd
      for subPattern, subVal of val
        patterns[pattern][subPattern].role = plugin
    else
      patterns[pattern].role = plugin

  @add patterns.addTodo, addTodo
  @add patterns.get.one, getOneTodo
  @add patterns.get.many, getTodos
  @add patterns.updateTodo, updateTodo
  @add patterns.deleteTodo, deleteTodo
