angular.module('Wadi.controllers.external', [])
.controller 'ExternalDataCtrl', ($scope, wdInterfaceApi, $interval, $http, wdExternalSegment, wdToast) ->
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

  $scope.createSegments = () ->
    wdExternalSegment.new_segments($scope.unsegmented_count)
    .then (res) ->
      if res
        wdToast "Segmentation Request", "Your segmentation request has been processed successfully", 'success'
      else
        wdToast "Segmentation Request", "An Error has occurred during segmentation", 'error'

  $scope.scheduleJob = (seg_num) ->
    if seg_num
      wdExternalSegment.old_segment(seg_num)
      .then (res) ->
        if res
          wdToast "Job Scheduling", "The job has been successfully scheduled", 'success'
        else
          wdToast "Segmentation Request", "An Error has occurred during the request", 'error'
