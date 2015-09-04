angular.module('Wadi.controllers.main', [])
.controller 'MainCtrl', ($scope, $state, $http, $log, wdLinks, wdInterfaceApi) ->
  $log.debug "Main executed"
  $state.go('login')

  isLoggedIn = false

  $scope.checkLogin = () -> isLoggedIn

  $scope.sheet_link = wdLinks.scheduling_sheet
  $scope.doc_link = wdLinks.docs

  $scope.login = (username, pass) ->
    $log.debug "Got submission #{username}, #{pass}"
    $http.post wdInterfaceApi.login, {
      username: username,
      password: pass
    }
    .success (result) ->
      $log.debug "Got result: #{JSON.stringify(result)}"
      isLoggedIn = result.success
      if isLoggedIn
        $state.go('dashboard')
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

.controller 'TestCtrl', ($scope, $state, $log, wdLinks, $modal, Upload, wdBlockApi) ->
  $scope.submit = () ->
    if $scope.file && !$scope.file.$error
      $scope.upload($scope.file)

  $scope.upload = (file) ->
    Upload.upload({
      url: wdBlockApi.upload
      file: file
    }).progress((evt) ->
      progPerc = parseInt(100.0 * evt.loaded / evt.total )
      $log.info "Progress: #{progPerc}% #{evt.config.file.name}"
    ).success (data) ->
      $log.info "Got result: "+JSON.stringify(data)
