module.exports = ($location, $compile) ->
  restrict: 'E',
  controller: 'navCtrl'
  templateUrl: '../../templates/login.html'
  link: (scope, element, attr) ->
    if $location.url() is '/' or $location.url() is '/register'
      element.css('display','none')