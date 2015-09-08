###
  Block list View form
###
angular.module('Wadi.controllers.block_list', [])
.controller 'BlockListCtrl', ($log, $scope, $state, Upload, $timeout, $http, wdBlockApi, wdToast) ->
  if not $scope.$parent.checkLogin()
    $state.go 'login'

  $scope.uploading = false
  $scope.report = {}

  $http.get wdBlockApi.count
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
      url: wdBlockApi.upload
      file: file
    ).success (data) ->
      $log.info "Got result: "+JSON.stringify(data)
      $scope.uploading = false
      if data.success
        wdToast("Block List added",
          "The block list was processed succfully and the given data added to the server", "success")
        $scope.report = {}
        if data.blocked
          $scope.report.blocked = data.blocked
        if data.total_blocked
          $scope.report.total_blocked = data.total_blocked
      else
        wdToast("Block List failed",
          "There was a problem processing the request, please check your file contents", "error")

      $timeout(() ->
        $scope.message = null
      , 1000)
