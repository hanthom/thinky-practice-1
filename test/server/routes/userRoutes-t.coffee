should = require('chai').should()
expect = require('chai').expect()

{pristineUser} = require "../../util"

host = "#{process.env.EXPRESS_HOST}:#{process.env.EXPRESS_PORT}"
api = require('supertest') host
userUrl = '/api/users'

describe 'userRoutes', ()->
  describe 'post', ()->
    res = {}
    newUser = {}
    before (done)->
      api
        .post userUrl
        .send pristineUser()
        .end (err, response)->
          if err then console.log "userRoutes TEST ERROR >>>> ", err
          else
            newUser = response.body
            console.log 'NEW USER >>>>', newUser
            res = response
          done()

    after (done)->
      {db} = require "#{__dirname}/../../../src/server-assets/config/dbConfig"
      {r} = db
      r.table 'User'
        .get newUser.id
        .delete()
        .then (res)->
          console.log 'CLEANUP >>>>', res
          done()

    it 'should return 201', (done)->
      res.status.should.equal 201
      done()

    it 'should not return the password', (done)->
      newUser.should.not.have.property 'password'
