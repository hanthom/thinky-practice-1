module.exports = ($location, $compile) ->
  scope:
    navItems: '='
  ,
  restrict: 'E',
  controller: 'navCtrl'
  templateUrl: '../../templates/navBar.html'
  link: (scope, element, attr) ->
    if $location.url() is '/' or $location.url() is '/register'
      element.css('display','none')
