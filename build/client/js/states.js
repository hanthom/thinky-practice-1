(function() {
  module.exports = function($urlRouterProvider, $stateProvider) {
    $urlRouterProvider.otherwise('home');
    return $stateProvider.state('home', {
      url: '/',
      controller: 'homeCtrl',
      templateUrl: '../templates/home'
    }).state('page', {
      url: '/page',
      controller: 'homeCtrl',
      templateUrl: '../templates/page'
    });
  };

}).call(this);
