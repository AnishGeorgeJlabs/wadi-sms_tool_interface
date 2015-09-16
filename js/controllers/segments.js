// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('Wadi.controllers.segments', []).controller('wdSegmentCtrl', function($scope, wdInterfaceApi, wdConfirm, $http, $log, job, debug) {
    var submit;
    $log.debug("Job : " + JSON.stringify(job));
    $scope.id = job._id;
    $scope.t_id = job.t_id;
    $scope.total = job.count;
    $scope.submitting = false;
    $scope.data = [];
    $scope.addSegment = function() {
      return $scope.data.push({
        english: '',
        arabic: '',
        date: ''
      });
    };
    $scope.removeSegment = function() {
      return $scope.data.pop();
    };
    $scope.addSegment();
    $scope.confirmAndSubmit = function() {
      return wdConfirm("Confirm form submission", "Are you sure you want to create these segments?").then(function(res) {
        if (res) {
          return submit();
        }
      });
    };
    $scope.currentValid = function() {
      return _.reduce($scope.data, function(res, obj) {
        return res && obj.english !== '' && obj.arabic !== '' && obj.date !== '';
      }, true);
    };
    return submit = function() {
      var res, segments;
      $scope.submitting = true;
      segments = _.map($scope.data, function(obj) {
        return _.mapObject(obj, function(v, k) {
          if (k === 'date') {
            return parseInt(moment(v).format('x'));
          } else {
            return v;
          }
        });
      });
      res = {
        debug: debug,
        ref_job: $scope.id,
        t_id: $scope.t_id,
        total: $scope.total,
        segments: segments
      };
      $log.debug("About to send: " + JSON.stringify(res));
      return $http.post(wdInterfaceApi.new_segment, res).success(function(res) {
        $log.info("Got result: " + (JSON.stringify(res)));
        $scope.submitting = false;
        return $scope.$close(true);
      });
    };
  }).controller('wdExternalSegmentCtrl', function($scope, $log, wdInterfaceApi, $http, wdConfirm, options, segments) {
    var counter, i, len, s, submit;
    $scope.showDetails = options.showDetails;
    $scope.is_new = options.is_new;
    $scope.data = [];
    $scope.debug = false;
    if (options.init_seg) {
      counter = options.init_seg;
    } else {
      counter = 1;
    }
    $scope.addSegment = function(snum) {
      var seg_num;
      if (snum) {
        seg_num = snum;
      } else {
        seg_num = counter;
        counter += 1;
      }
      return $scope.data.push({
        segment_number: seg_num,
        name: '',
        arabic: '',
        english: '',
        date: null,
        language: 'Both',
        country: 'Both'
      });
    };
    if (!$scope.is_new) {
      for (i = 0, len = segments.length; i < len; i++) {
        s = segments[i];
        $scope.addSegment(s);
      }
    } else {
      $scope.addSegment();
    }
    if ($scope.showDetails) {
      $scope.total = options.total;
    }
    $scope.removeSegment = function() {
      return $scope.data.pop();
    };
    $scope.confirmAndSubmit = function() {
      return wdConfirm("Confirm form submission", "Are you sure you want to create these segments?").then(function(res) {
        if (res) {
          return submit();
        }
      });
    };
    return submit = function() {
      var res;
      $log.debug("Submitting with segments: " + JSON.stringify($scope.data));
      $scope.submitting = true;
      segments = _.map($scope.data, function(obj) {
        return _.mapObject(obj, function(v, k) {
          if (k === 'date') {
            return parseInt(moment(v).format('x'));
          } else {
            return v;
          }
        });
      });
      res = {
        debug: $scope.debug,
        is_new: $scope.is_new,
        segments: segments
      };
      $log.debug("About to send: " + JSON.stringify(res));
      return $http.post(wdInterfaceApi.segment_jobs_external, res).then(function(response) {
        $log.info("Got result: " + JSON.stringify(response.data));
        $scope.submitting = false;
        if (response.data.success) {
          return $scope.$close(true);
        } else {
          return $scope.$close(false);
        }
      }, function(response) {
        $log.info("Error: " + JSON.stringify(response));
        return $scope.$close(false);
      });
    };
  });

}).call(this);

//# sourceMappingURL=segments.js.map
