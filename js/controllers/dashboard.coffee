###
  Dashboard controller
###

angular.module('Wadi.controllers.dashboard', [])
.controller 'DashboardCtrl', ($scope, $state, $log, $http, $interval, wdInterfaceApi, wdConfirm, wdSegment, wdToast) ->
  if not $scope.$parent.checkLogin()
    $state.go 'login'

  $scope.tab = 'jobs'

  $scope.changeTabTo = (tb) ->
    $scope.tab = tb

  $scope.isTab = (tb) ->
    $scope.tab == tb



  store_job_data = (dt) ->
    $scope.job_data = _.map(dt, (obj) ->
      obj._id = obj._id.$oid
      obj.timestamp = obj.timestamp.$date
      obj
    )

  store_segment_data = (dt) ->
    $scope.segment_data = _.map(dt, (obj) ->
      obj.ref_job = obj.ref_job.$oid
      obj.timestamp = obj.timestamp.$date
      obj
    )
    # $log.info "Segment data: "+JSON.stringify($scope.segment_data)

  # store_data(sampleData)

  refresh = () ->
    $http.get wdInterfaceApi.jobs
    .success (data) ->
      if data.success
        store_job_data(data.data)
      else
        $log.warning "Problem fetching data: "+JSON.stringify(data)

    $http.get wdInterfaceApi.segment_jobs
    .success (data) ->
      if data.success
        store_segment_data(data.data)
      else
        $log.warning "Problem fetching segment data: "+JSON.stringify(data)


  refresh()

  periodicRefresh = $interval( () ->
    refresh()
  , 10000)

  $scope.$on("$destroy", () ->
    $interval.cancel(periodicRefresh)
  )

  $scope.confirmAndCancelJob = (oid, t_id) ->
    if not t_id
      message = "the given job?"
    else
      message = "Job #{t_id}?"

    full_message = "Are you sure you want to cancel #{message}? This is an irreversible action!"
    wdConfirm("Confirm cancellation", full_message)
    .then (res) ->
      if res
        $scope.cancelJob(oid, t_id)


  $scope.cancelJob = (oid, t_id) ->
    obj = {
      id: oid
    }
    if t_id != undefined
      obj.t_id = t_id

    $log.debug "About to post: "+JSON.stringify(obj)
    $http.post(wdInterfaceApi.cancel_job, obj)
    .success (data) ->
      if data.success
        wdToast("Job Cancellation", "The Job has been cancelled, the dashboard will refresh shortly", "info")

  $scope.segment = (job) ->
    wdSegment(job)
    .then (res) ->
      if res
        wdToast("Success",
          "Successfully processed your request for segmentation, you should see the results in the sheet shortly", "success")

