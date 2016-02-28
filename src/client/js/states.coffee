module.exports = ($urlRouterProvider, $stateProvider) ->
  $urlRouterPRovider.otherwise 'home'
  $stateProvider
    .state 'home',
      url: '/'
      controller: 'homeCtrl'
      templateUrl: '../templates/home'
    .state 'page',
      url: '/'
      controller: 'homeCtrl'
      templateUrl: '../templates/page'
