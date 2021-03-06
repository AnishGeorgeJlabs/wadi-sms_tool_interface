angular.module('Wadi.controllers.external', [])
.controller 'ExternalDataCtrl', ($state, $log, $scope, wdInterfaceApi, $interval, $http, wdExternalSegment, wdToast, wdConfirm) ->
  if not $scope.$parent.checkLogin()
    $state.go('login')
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
    init_seg = _.last($scope.data).segment_number + 1
    wdExternalSegment.new_segments($scope.unsegmented_count, init_seg)
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

  $scope.confirmAndCancelJob = (segment_number, job_number) ->
    wdConfirm("Confirm cancellation", "Are you sure you want to cancel Segment ##{segment_number}, Job ##{job_number+1}?")
    .then (res) ->
      if res
        cancelJob(segment_number, job_number)

  cancelJob = (segment_number, job_number) ->
    $http.post(wdInterfaceApi.cancel_job, {
      segment_number: segment_number
      job_number: job_number
    }).success (data) ->
      if data.success
        wdToast("Cancellation", "The requested job has been cancelled successfully", "info")
        refresh()
