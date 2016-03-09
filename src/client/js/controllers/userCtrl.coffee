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
          $scope.registerError.visibility = false
          $scope.visible = true
          $state.go 'thankyou'
        .catch (e)->
          $scope.registerError =
            visibility: true
            message: e
    else
      $scope.registerError =
        visibility: true
        message: "Invalid Email"
