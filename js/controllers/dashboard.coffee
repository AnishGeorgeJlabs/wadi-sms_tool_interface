###
  Dashboard controller
###

angular.module('Wadi.controllers.dashboard', [])
.controller 'DashboardCtrl', ($scope, $state, $log, $http, $interval, wdInterfaceApi, wdConfirm) ->
  if not $scope.$parent.checkLogin()
    $state.go 'login'

  sampleData = [
    {
      name: "Sample Job"
      status: "Data Loaded"
      t_id: 35
      count: 610
      file: "http://jlabs.co/downloadcsv.php?file=res_56.csv"
      _id:
        $oid: "55e5587e21aaec7ec1b48247"
      description: "This is a long sample description for the job. It has many additional information, which we are not interested in"
      timestamp:
        $date: 1441113558632
      start_date: "09/01/2015"
      repeat: "Hourly"
    }
  ]

  store_data = (dt) ->
    $scope.data = _.map(dt, (obj) ->
      obj._id = obj._id.$oid
      obj.timestamp = obj.timestamp.$date
      obj
    )

  # store_data(sampleData)

  refresh = () ->
    $http.get wdInterfaceApi.jobs
    .success (data) ->
      if data.success
        store_data(data.data)
      else
        $log.warning "Problem fetching data: "+JSON.stringify(data)

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
      $log.info "Job canceled successfully: "+JSON.stringify(data)


