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
    )

.controller 'wdSegmentCtrl', ($scope, wdInterfaceApi, wdConfirm, $http
                              $log,
                              job, debug) ->
  $log.debug "Job : "+JSON.stringify(job)

  $scope.id = job.id.$oid
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
    wdInterfaceApi.new_segment
