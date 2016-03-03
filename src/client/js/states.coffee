module.exports = ($urlRouterProvider, $stateProvider, $httpProvider)->
  $httpProvider.interceptors.push ($q, $location)->
    responseError: (res)->
      if res.status is 401
        $location.path '/login'
        $q.reject res
      $q.reject()
  $urlRouterProvider.otherwise '/'
  $stateProvider
    .state 'login',
      url:'/'
      controller: 'loginCtrl'
      templateUrl: '../templates/login.html'
    .state 'logout',
      controller: ($state, authService)->
        authService.logout()
          .then ()->
            $state.go 'login'
    .state 'register',
      url: '/register'
      controller: 'registerCtrl'
      templateUrl: '../templates/register.html'
    .state 'secured',
      abstract: true
      template: '<nav></nav><ui-view/>'
      resolve:
        user: (authService)->
          authService.getAuth()
    .state 'secured.list',
      url: '/todos/:status'
      controller: 'listCtrl'
      templateUrl: '../templates/list.html'
      resolve:
        list: ($stateParams, todoService) ->
          todoService.getTodos $stateParams.status
        title: ($stateParams)->
          $stateParams.status
    .state 'secured.home',
      url: '/home'
      controller: 'homeCtrl'
      templateUrl: '../templates/home.html'
      resolve:
        list: (todoService) ->
          todoService.getTodos 'all'
