angular.module('Wadi.services', [])
.factory 'testFn', ($log) ->
  () ->
    $log.debug "Test function executed" # Okay, works

.factory 'wdConfirm', ($modal) ->
  (title, message, sz) ->
    if sz
      size = sz
    else
      size = 'sm'
    $modal.open(
      templateUrl: 'templates/modals/modal_confirm.html'
      size: size
      controller: ($scope) ->
        $scope.message = message
        $scope.title = title
    ).result

.factory 'wdSegment', ($modal) ->
  () ->
    $modal.open(
      templateUrl: 'templates/modals/modal_segment_job.html'
      backdrop: 'static'
      keyboard: false
    )
