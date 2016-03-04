should = require('chai').should()
expect = require('chai').expect()

{pristineUser} = require "../../util"

host = "#{process.env.EXPRESS_HOST}:#{process.env.EXPRESS_PORT}"
api = require('supertest') host
userUrl = '/api/users/'
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
            newUser = response.body
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
            console.log 'DB cleaned'
            done()
      else
        done()

    it 'should return 201', (done)->
      res.status.should.equal 201
      done()

    it 'should return username', (done)->
      newUser.should.have.property 'username'
      done()

    it 'should not return password, email, nor id', (done)->
      newUser.should.not.have.property 'password'
      newUser.should.not.have.property 'email'
      newUser.should.not.have.property 'id'
      done()

    describe 'errors', ()->
      it 'should reject misformatted users', (done)->
        user = pristineUser()
        delete user.username
        api
          .post userUrl
          .send user
          .end (err, res)->
            console.log 'TEST ERROR >>>> ', err
            done()

  describe 'get', ()->
    describe 'all', ()->
      users = null
      before (done)->
        api
          .get "#{userUrl}"
          .end (err, response)->
            users = response.body
            done()

      it 'should return an array of users', (done)->
        users.should.be.a 'array'
        done()

      it 'should not return password, email, nor createdAt', (done)->
        for user in users
          user.should.not.have.property 'password'
          user.should.not.have.property 'email'
          user.should.not.have.property 'createdAt'
        done()
