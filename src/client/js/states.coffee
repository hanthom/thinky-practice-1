module.exports = ($urlRouterProvider, $stateProvider) ->
  $urlRouterProvider.otherwise 'home'
  $stateProvider
    .state 'home',
      url: '/'
      controller: 'homeCtrl'
      templateUrl: '../templates/home'
    .state 'page',
      url: '/page'
      controller: 'homeCtrl'
      templateUrl: '../templates/page'
