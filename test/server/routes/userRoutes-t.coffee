supertest = require 'supertest'
should = require('chai').should()

{db, pristineUser} = require "../../util"
{clean, insertDoc, r} = db

api = supertest "#{process.env.EXPRESS_HOST}:#{process.env.EXPRESS_PORT}"
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
            res = response
          done()

    after (done)->
      clean 'User'
        .then ()->
          done()

    it 'should return 201', (done)->
      res.status.should.equal 201
      done()

    it 'should return username and id', (done)->
      newUser.should.have.property 'username'
      done()

    it 'should not return password, email, nor createdAt', (done)->
      newUser.should.not.have.property 'password'
      newUser.should.not.have.property 'email'
      done()

    # describe 'errors', ()->
    #   it 'should reject misformatted users', (done)->
    #     user = pristineUser()
    #     delete user.username
    #     api
    #       .post userUrl
    #       .send user
    #       .end (err, res)->
    #         console.log 'TEST ERROR >>>> ', err
    #         done()

  describe 'get', ()->
    describe 'all', ()->
      users = null
      before (done)->
        api
          .get userUrl
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
          user.should.not.have.property 'id'
        done()

    describe 'one', ()->
      {User} = require "#{__dirname}/../../../src/server-assets/models/models"
      fetchedUser = null
      res = null
      newUser = pristineUser()
      before 'insert doc', (done)->
        insertDoc User, newUser
          .then ()->
            done()

      after (done)->
        clean 'User'
          .then ()->
            done()

      beforeEach (done)->
        api
          .get "#{userUrl}/#{newUser.username}"
          .end (err, response)->
            res = response
            console.log 'res.body', res.body
            fetchedUser = res.body
            done()

      it 'should have a 200 status', (done)->
        res.status.should.equal 200
        done()

      it 'should return an object', (done)->
        fetchedUser.should.be.a 'object'
        done()

      it 'should fetch the right user', (done)->
        fetchedUser.username.should.equal newUser.username
        done()
