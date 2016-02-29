should = require('chai').should()
{pristineUser} = require "../../util"
api = require('supertest') 'http://localhost:8888'
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

