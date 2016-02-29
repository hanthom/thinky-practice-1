# paths =
#   server: '../../../src/server-assets/'
# userCtrl = require "#{paths.server}controllers/userCtrl"
# User = require "#{paths.server}models/User"
# {startTest, endTest} = require "../../config"
# {pristineUser} = require "../../util"
#
# describe 'user', ()->
#
#   before (done)->
#     done()
#   after (done)->
#     done()
#
#   describe 'submitUser', ()->
#     newUser = pristineUser()
#     userIds = []
#     user = {}
#     before (done)->
#       userCtrl.createUser newUser, (err, id)->
#         if err then console.log 'error submiting user', err
#         if !id then console.log 'no user returned'
#         User
#           .get id
#           .run()
#           .then (u)->
#             user = u
#           .catch (e)->
#             console.log 'Error getting user', e.message
#         userIds.push id
#         console.log 'userIds:', userIds
#         done()
#     after (done)->
#       done()
#     it 'should create a new user', (done)->
#       user.should.exist
#       done()
#     it 'should return a user with hashed password', (done)->
#       user.password.should.not.equal 'test'
#       done()
#   describe 'getByUsername', ()->
#     it 'should find & return a user given an existing username', (done)->
#       done()
