module.exports = ($urlRouterProvider, $stateProvider) ->
  $urlRouterProvider.otherwise '/'
  $stateProvider
    .state 'home',
      url: '/'
      controller: 'homeCtrl'
      templateUrl: '../templates/home.html'
    .state 'page',
      url: '/page'
      controller: 'homeCtrl'
      templateUrl: '../templates/page.html'
