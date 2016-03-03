supertest = require 'supertest'
should = require('chai').should()

{db, pristineUser} = require "../../util"
{clean, insertDoc, r} = db

api = supertest "#{process.env.EXPRESS_HOST}:#{process.env.EXPRESS_PORT}"
authUrl = '/api/auth'

describe 'authRoutes', ()->
  describe 'get', () ->
    describe 'local', () ->
      user = null
      before (done) ->
        api
          .get authUrl
          .end (err, response) ->
            user = response.body
            done()

    it 'should return an object of user', (done) ->
      user.should.be.a 'object'
      done()

    it 'should return email, username', (done) ->
      user.should.have.property 'email'
      user.should.have.property 'username'
      done()

    
