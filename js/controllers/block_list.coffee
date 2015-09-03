###
  Block list View form
###
angular.module('Wadi.controllers.block_list', [])
.controller 'BlockListCtrl', ($log, $scope, $state, Upload, $timeout, $http) ->
  if not $scope.$parent.checkLogin()
    $state.go 'login'

  $scope.uploading = false
  $scope.report = {}

  $http.get "http://45.55.72.208/wadi/block_list/count"
  .success (data) ->
    if data.success
      $scope.report.total_blocked =
        email: data.email
        phone: data.phone

  # For testing
  ###
  $scope.report =
    blocked:
      email: 10
      phone: 30
    total_blocked:
      email: 1532
      phone: 591

  ###

  $scope.submit = () ->
    if $scope.blockForm.file.$valid && $scope.file && !$scope.file.$error
      $scope.upload($scope.file)
    else
      $log.debug "Didn't upload!!"

  $scope.upload = (file) ->
    $scope.uploading = true
    Upload.upload(
      url: 'http://45.55.72.208/wadi/block_list/upload'
      file: file
    ).success (data) ->
      $log.info "Got result: "+JSON.stringify(data)
      $scope.uploading = false
      if data.success
        $scope.message = "Block list processed successfully"
        $scope.report = {}
        if data.blocked
          $scope.report.blocked = data.blocked
        if data.total_blocked
          $scope.report.total_blocked = data.total_blocked
      else
        $scope.message = "There was a problem processing the request, please check your file contents"

      $timeout(() ->
        $scope.message = null
      , 1000)