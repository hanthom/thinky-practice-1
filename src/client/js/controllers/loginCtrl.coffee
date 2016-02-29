module.exports = ($scope, authService)->
  $scope.login = (credentials)->
    authService.login credentials
      .then (res)->
        $scope.credentials = {}
        $state.go 'secured.home'
      .catch (e)->
        console.log 'Err', e
        credentials = {}
