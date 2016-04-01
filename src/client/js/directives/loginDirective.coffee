module.exports = ($location, $compile) ->
  restrict: 'E',
  controller: 'navCtrl'
  templateUrl: '../../templates/login.html'
  link: (scope, element, attr) ->
    if $location.url() is '/'
      element.css('display','none')
