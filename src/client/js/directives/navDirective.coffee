module.exports = ($location, $compile) ->
  scope:
    navItems: '='
  ,
  restrict: 'E',
  controller: 'navCtrl'
  templateUrl: '../../templates/navBar.html'
  link: (scope, element, attr) ->
    if $location.url() is '/login' or $location.url() is '/register'
      element.find('ul')[0].innerHTML = '<li>\
      <a href="#/register" ui-sref="register" class="alter">Register</a>\
      </li>\
      <li>\
      Make This Work\
      </li>'
      console.log "User not logged in", $location.url()
