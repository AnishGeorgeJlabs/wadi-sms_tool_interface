angular.module('Wadi.controllers.main', [])
.controller 'MainCtrl', ($scope, $state, $http, $log, wdLinks, wdInterfaceApi) ->
  $log.debug "Main executed"
  $state.go('login')
  $scope.creds =
    username: ''

  isLoggedIn = false

  $scope.checkLogin = () -> isLoggedIn

  $scope.sheet_link = wdLinks.scheduling_sheet
  $scope.doc_link = wdLinks.docs

  $scope.login = (username, pass) ->
    $log.debug "Got submission #{username}, #{pass}"
    $scope.creds.username = username
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

  $scope.logout = () ->
    isLoggedIn = false
    $state.go('login')


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

.controller 'TestCtrl', ($scope, $modal, $log, wdExternalSegment) ->

  $scope.openModal = () ->
    wdExternalSegment.new_segments(4)
  ###
  $scope.openModal = () ->
    $log.debug "AccessingopenModal"
    $modal.open(
      templateUrl: 'templates/modals/modal_external_segment.html'
      backdrop: 'static'
      size: 'lg'
      keyboard: false
      resolve: {
        options: () ->
          showDetails: true
          is_new: true
          total: 14100
        segments: () -> [1,2]
      }
      controller: 'wdExternalSegmentCtrl'
    )

  ###
