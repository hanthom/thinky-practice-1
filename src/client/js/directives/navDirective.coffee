module.exports = ($location) ->
  scope:
    navItems: '='
  ,
  restrict: 'E',
  controller: 'navCtrl'
  templateUrl: '../../templates/navBar.html'
  link: (scope, element, attr) ->
    if scope.authed
      console.log "Did the thing"
    else
      console.log "User not logged in"
