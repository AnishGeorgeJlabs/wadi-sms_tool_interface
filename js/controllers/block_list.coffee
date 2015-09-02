###
  Block list View form
###
angular.module('Wadi.controllers.block_list', [])
.controller 'BlockListCtrl', ($log, $scope, $state, Upload) ->
  if not $scope.$parent.checkLogin()
    $state.go 'login'

  $scope.submit = () ->
    if $scope.blockForm.file.$valid && $scope.file && !$scope.file.$error
      $scope.upload($scope.file)
    else
      $log.debug "Didn't upload!!"

  $scope.upload = (file) ->
    Upload.upload(
      url: 'http://45.55.72.208/wadi/block_list/upload'
      file: file
    ).success (data) ->
      alert "Successfully uploaded the file"
      $log.info "Got result: "+JSON.stringify(data)
