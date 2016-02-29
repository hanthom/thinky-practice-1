should = require('chai').should()
{pristineUser} = require "../../util"
host = 'http://localhost:9999'
api = require('supertest') host
userUrl = '/api/users'

describe 'userRoutes', ()->
  describe 'post', ()->
    res = {}
    before (done) ->
      api
        .post userUrl
        .send pristineUser()
        .end (err, r)->
          if err then console.log "userRoutes ERROR >>>> ", err
          else console.log "userRoutes STATUS >>>> " , r.status
          res = r
          console.log "REST BEFORE DONE >>>> ", res.status
      done()

    console.log "RES BEFORE IT >>>> ", res.status
    it 'should return a 201', (done)->
      console.log "IT RES >>>> ", res.status
      res.status.should.equal 201
      done()
