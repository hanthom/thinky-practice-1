module.exports = ($scope, authService, userService)->
  $scope.visible = true

  $scope.showRegister = () ->
    $scope.visible = ! $scope.visible

  $scope.login = (credentials)->
    authService.login credentials
      .then (res)->
        $scope.credentials = {}
        $state.go 'secured.home'
      .catch (e)->
        console.log 'Err', e
        credentials = {}

  $scope.register = (credentials)->
    userService.addUser credentials
      .then (res)->
        $scope.credentials = {}
        # $state.go 'secured.home'
      .catch (e)->
        console.log 'Err', e
        credentials = {}
