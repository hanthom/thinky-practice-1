testDb =
    host: 'localhost'
    port: 28015
    db: 'reactTodoTest'
module.exports =
  mochaSetup:
    reporter: null
  startTest: (name)->
    process.env['DB'] = testDb
  endTest: ()->
    if process.env['DB'] then delete process.env['DB']


