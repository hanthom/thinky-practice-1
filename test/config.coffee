module.exports =
  mochaSetup:
    reporter: 'nyan'
  startTest: ()->
    process.env['DB'] = testDb

  endTest: ()->
    if process.env['DB'] then delete process.env['DB']
