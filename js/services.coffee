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

.factory 'wdToast', () ->
  if !window.toastr
    (title, message) ->
      alert title + ":  " + message
  else
    toastr.options =
      closeButton: true
      debug: false
      positionClass: "toast-bottom-full-width"
      preventDuplicate: true
      onclick: null
      showDuration: 300
      hideDuration: 1000
      timeout: 4000
      extendedTimeOut: 0
      showEasing: "swing"
      hideEasing: "linear"
      showMethod: "fadeIn"
      hideMethod: "fadeOut"

    (title, message, style="success") ->
      toastr[style](message, title)
      return true       # So that we do not return DOM element and angular doesn't complain

.factory 'wdSegment', ($modal) ->
  (job, debug) ->
    $modal.open(
      templateUrl: 'templates/modals/modal_segment_job.html'
      backdrop: 'static'
      size: 'lg'
      keyboard: false
      resolve: {
        job: () ->
          job
        debug: () ->
          if debug
            debug
          else
            false
      }
      controller: 'wdSegmentCtrl'
    ).result

.controller 'wdSegmentCtrl', ($scope, wdInterfaceApi, wdConfirm, $http
                              $log,
                              job, debug) ->
  $log.debug "Job : "+JSON.stringify(job)

  $scope.id = job._id
  $scope.t_id = job.t_id
  $scope.total = job.count

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
      $scope.$close(true)
