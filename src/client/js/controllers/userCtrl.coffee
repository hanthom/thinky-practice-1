module.exports = ($scope, $state, authService, userService)->
  $scope.visible = true
  $scope.registerError =
    visibility: false
    message: ""
  $scope.showRegister = () ->
    $scope.visible = ! $scope.visible

  $scope.login = (credentials)->
    authService.login credentials
      .then (res)->
        $scope.credentials = {}
        # $state.go 'secured.home'
      .catch (e)->
        console.log 'Err', e
        credentials = {}

  $scope.register = (credentials)->
    re = /\S+@\S+\.\S+/
    if re.test(credentials.email)
      userService.addUser credentials
        .then (res)->
          
        .catch (e)->
          console.log 'Err', e
          credentials = {}
    else
      $scope.registerError =
        visibility: true
        message: "Invalid Email"
