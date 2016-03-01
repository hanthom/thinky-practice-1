should = require('chai').should()
expect = require('chai').expect()

{pristineUser} = require "../../util"

host = "#{process.env.EXPRESS_HOST}:#{process.env.EXPRESS_PORT}"
api = require('supertest') host
userUrl = '/api/users'
src = "#{__dirname}/../../../src/"

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
            console.log 'RESPONSE >>>>', response.body
            res = response
          done()

    after (done)->
      {db} = require "#{src}/server-assets/config/dbConfig"
      {r} = db
      if newUser.test
        r.table 'User'
          .filter test: true
          .delete()
          .then (res)->
            console.log 'CLEANUP >>>>', res
            done()
      else
        done()

    it 'should return 201', (done)->
      res.status.should.equal 201
      done()

    it 'should return username and id', (done)->
      newUser.should.have.property 'id'
      newUser.should.have.property 'username'
      done()

    it 'should not return password, email, nor createAt', (done)->
      newUser.should.not.have.property 'password'
      newUser.should.not.have.property 'email'
      newUser.should.not.have.property 'createAt'
      done()
