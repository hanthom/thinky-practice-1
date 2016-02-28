angular = require 'angular'
require 'angular-ui-router'

angular.module 'todoApp', ['ui.router']
  .config require './states'

require './services/services'
require './controllers/controllers'
