module.exports = ($scope, userService)->
  $scope.register = (credentials)->
    userService.addUser credentials
      .then (res)->
        $scope.credentials = {}
        # $state.go 'secured.home'
      .catch (e)->
        console.log 'Err', e
        credentials = {}
