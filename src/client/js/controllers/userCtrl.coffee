module.exports = ($scope, $state, userService, authService)->
  $scope.formToggle = true
  $scope.registerError =
    visibility: false
    message: ""
  $scope.showRegister = () ->
    $scope.formToggle = ! $scope.formToggle

  $scope.login = (credentials)->
    authService.localLogin credentials
      .then (res)->
        $scope.credentials = {}
        console.log "Res from localLogin", res
        $state.go 'thankyou'
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
