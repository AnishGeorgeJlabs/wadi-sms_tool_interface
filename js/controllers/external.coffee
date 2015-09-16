angular.module('Wadi.controllers.external', [])
.controller 'ExternalDataCtrl', ($scope, wdInterfaceApi, $interval, $http) ->
  $scope.data = []
  $scope.unsegmented_count = 0

  refresh = () ->
    $http.get wdInterfaceApi.segment_jobs_external
    .success (data) ->
      if data.success
        $scope.data = data.data
        $scope.unsegmented_count = data.unsegmented
      else
        $log.debug "Didn't get correct data for external jobs"

  refresh()
  periodicRefresh = $interval( () ->
    refresh()
  , 10000)

  $scope.$on("$destroy", () ->
    $interval.cancel(periodicRefresh)
  )
