should = require('chai').should()
{pristineUser} = require "../../util"
host = 'http://localhost:8888'
api = require('supertest') host
userUrl = '/api/user'

describe 'userRoutes', ()->
  describe 'post', ()->
    res = {}
    api
      .post userUrl
      .send pristineUser()
      .end (err, r)->
        res = r
    it 'should return a 201', (done)->
      res.status.should.equal 201
      done()
