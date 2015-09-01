angular.module('Wadi.controllers.main', [])
.controller 'MainCtrl', ($scope, $state, $http, $log, wdLinks) ->
  $log.debug "Main executed"
  $state.go('login')

  isLoggedIn = false

  $scope.checkLogin = () -> isLoggedIn

  $scope.sheet_link = wdLinks.scheduling_sheet
  $scope.doc_link = wdLinks.docs

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


  $scope.isState = (statename) ->
     $state.is(statename)

  $scope.goTo = (statename) ->
    $state.go(statename)


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

.controller 'TestCtrl', ($scope, $state, $log, wdLinks, $modal) ->
  $scope.sOpts = [
    { name: 'Option 1'},
    { name: 'Option 2'},
    { name: 'Option 3'}
  ]
  $scope.sample =
    name: 'Something I guess'
    values: ['Option1', 'Option2', 'Option3']
    co_type: 'both'
  $scope.selected =
    value: ''
    co_type: 'required'


