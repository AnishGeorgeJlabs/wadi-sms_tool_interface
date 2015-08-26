angular.module('Wadi.controllers.main', [])
.controller 'MainCtrl', ($scope, $state, $http, $log) ->
  $log.debug "Main executed"
  $state.go('login')

  isLoggedIn = false

  $scope.checkLogin = () -> isLoggedIn

  $scope.login = (username, pass) ->
    $log.debug "Got submission #{username}, #{pass}"
    $http.post "http://45.55.72.208/wadi/interface/login", {
      username: username,
      password: pass
    }
    .success (result) ->
      $log.debug "Got result: #{JSON.stringify(result)}"
      isLoggedIn = result.success
      if isLoggedIn
        $state.go('form')
      else
        alert "Authentication failed"


.controller 'LoginCtrl', ($scope, $log) ->
  $scope.data = {
    username: ''
    password: ''
  }

  $scope.submit = () ->
    $log.debug "Submitting : #{JSON.stringify($scope.data)}"
    $scope.$parent.login($scope.data.username, md5($scope.data.password))
    $scope.data.username = ''
    $scope.data.password = ''

.controller 'TestCtrl', ($scope, $state, $log) ->
  $scope.data =
    selected: []
    set: ''
  $scope.sampleData = [
    'electronics', 'shoes', 'sports bags', 'goodies', 'long list', 'another useless item', 'someone else'
  ]
