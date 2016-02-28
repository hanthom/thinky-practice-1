angular = require 'angular'
require 'ui-router'

angular.module 'todoApp', ['ui.router']
  .config require './states'

require './controllers/controllers'
require './services/services'
