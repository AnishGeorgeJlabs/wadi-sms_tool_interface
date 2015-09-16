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

.factory 'wdExternalSegment', ($modal) ->
  basicOptions =
    templateUrl: 'templates/modals/modal_external_segment.html'
    backdrop: 'static'
    size: 'lg'
    keyboard: false
    controller: 'wdExternalSegmentCtrl'

  return {
    new_segments: (count, init_seg=1) ->
      basicOptions.resolve = {
        options: () ->
          showDetails: true
          is_new: true
          init_seg: init_seg
          total: count
        segments: () -> []
      }
      $modal.open(basicOptions).result

    old_segment: (seg_num) ->
      basicOptions.resolve = {
        options: () ->
          showDetails: false
          is_new: false
        segments: () -> [seg_num]
      }
      $modal.open(basicOptions).result
  }
