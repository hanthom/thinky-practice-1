(function() {
  var angular;

  angular = require('angular');

  require('ui-router');

  angular.module('todoApp', ['ui.router']).config(require('./states'));

  require('./services/services');

  require('./controllers/controllers');

}).call(this);
