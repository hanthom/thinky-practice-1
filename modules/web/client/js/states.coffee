module.exports = ($urlRouterProvider, $stateProvider, $httpProvider)->
  $httpProvider.interceptors.push ($q, $location)->
    responseError: (res)->
      # if res.status is 401
      #   $location.path '/login'
      #   $q.reject res
      # $q.reject()
      switch res.status
        when 403 or 404
          $q.reject res.data
        when 401
          $location.path '/login'
          $q.reject res
  $urlRouterProvider.otherwise '/'
  $stateProvider
    .state 'login',
      url:'/'
      controller: 'userCtrl'
      templateUrl: '../templates/login.html'

    .state 'thankyou',
      url:'/thankyou'
      templateUrl: '../templates/thankyou.html'

    .state 'logout',
      controller: ($state, authService)->
        authService.logout()
          .then ()->
            $state.go 'login'

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
