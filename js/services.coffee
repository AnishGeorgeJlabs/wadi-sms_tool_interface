angular.module('Wadi.services', [])
.factory 'testFn', ($log) ->
  () ->
    $log.debug "Test function executed" # Okay, works

.factory 'wdConfirm', ($modal) ->
  (message) ->
    $modal.open(
      templateUrl: 'templates/modals/modal_confirm.html'
      controller: ($scope, $modalInstance) ->
        $scope.message = message
        $scope.cancel = () ->
          $modalInstance.dismiss('cancel')
        $scope.ok = () ->
          $modalInstance.ok('ok')   # Todo
    )
