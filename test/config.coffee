module.exports =
  mochaSetup:
    reporter: null
  startTest: ()->
    process.env['DB'] = testDb

  endTest: ()->
    if process.env['DB'] then delete process.env['DB']
