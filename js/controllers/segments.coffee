angular.module('Wadi.controllers.segments', [])
.controller 'wdSegmentCtrl', ($scope, wdInterfaceApi, wdConfirm, $http
                              $log,
                              job, debug) ->
  $log.debug "Job : "+JSON.stringify(job)

  $scope.id = job._id
  $scope.t_id = job.t_id
  $scope.total = job.count

  $scope.submitting = false

  $scope.data = []
  $scope.addSegment = () ->
    $scope.data.push(
      english: ''
      arabic: ''
      date: ''
    )
  $scope.removeSegment = () ->
    $scope.data.pop()

  $scope.addSegment()

  $scope.confirmAndSubmit = () ->
    wdConfirm("Confirm form submission", "Are you sure you want to create these segments?")
    .then (res) ->
      submit() if res

  $scope.currentValid = () ->
    _.reduce($scope.data, (res, obj) ->
      res and obj.english != '' and obj.arabic != '' and obj.date != ''
    , true)

  submit = () ->
    $scope.submitting = true
    segments = _.map($scope.data, (obj) ->
      _.mapObject(obj, (v,k) ->
        if k == 'date'
          parseInt(moment(v).format('x'))
        else
          v
      )
    )
    res =
      debug: debug
      ref_job: $scope.id
      t_id: $scope.t_id
      total: $scope.total
      segments: segments

    $log.debug "About to send: "+JSON.stringify(res)
    $http.post(wdInterfaceApi.new_segment,res)
    .success (res) ->
      $log.info "Got result: #{JSON.stringify(res)}"
      $scope.submitting = false
      $scope.$close(true)

.controller 'wdExternalSegmentCtrl', ($scope, $log, wdInterfaceApi, $http, wdConfirm, options, segments) ->
  $scope.showDetails = options.showDetails
  $scope.is_new = options.is_new
  $scope.data = []
  $scope.debug = true

  counter = 1
  $scope.addSegment = (snum) ->
    if snum
      seg_num = snum
    else
      seg_num = counter
      counter += 1
    $scope.data.push({
      segment_number: seg_num
      arabic: ''
      english: ''
      date: null
      language: 'Both'
      country: 'Both'
    })

  if not $scope.is_new
    $scope.addSegment(s) for s in segments
  else
    $scope.addSegment()

  if $scope.showDetails
    $scope.total = options.total

  $scope.removeSegment = () ->
    $scope.data.pop()
  $scope.confirmAndSubmit = () ->
    wdConfirm("Confirm form submission", "Are you sure you want to create these segments?")
    .then (res) ->
      submit() if res

  submit = () ->
    $log.debug "Submitting with segments: "+JSON.stringify($scope.data)
    $scope.submitting = true
    segments = _.map($scope.data, (obj) ->
      _.mapObject(obj, (v,k) ->
        if k == 'date'
          parseInt(moment(v).format('x'))
        else
          v
      )
    )
    res =
      debug: $scope.debug
      is_new: $scope.is_new
      segments: segments

    $log.debug "About to send: "+JSON.stringify(res)
    $http.post(wdInterfaceApi.segment_jobs_external,res)
    .then(
      (response) ->
        $log.info "Got result: "+ JSON.stringify(response.data)
        $scope.submitting = false
        if response.data.success
          $scope.$close(true)
        else
          $scope.$close(false)
      , (response) ->
        $log.info "Error: "+ JSON.stringify(response)
        $scope.$close(false)
    )
    ###
    .success (res) ->
      $log.info "Got result: #{JSON.stringify(res)}"
      $scope.submitting = false
      $scope.$close(true)
    .failure (res) ->
      $scope.$close(false)
    j
###
