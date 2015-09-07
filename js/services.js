// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('Wadi.services', []).factory('testFn', function($log) {
    return function() {
      return $log.debug("Test function executed");
    };
  }).factory('wdConfirm', function($modal) {
    return function(title, message, sz) {
      var size;
      if (sz) {
        size = sz;
      } else {
        size = 'sm';
      }
      return $modal.open({
        templateUrl: 'templates/modals/modal_confirm.html',
        size: size,
        controller: function($scope) {
          $scope.message = message;
          return $scope.title = title;
        }
      }).result;
    };
  }).factory('wdSegment', function($modal) {
    return function(job, debug) {
      return $modal.open({
        templateUrl: 'templates/modals/modal_segment_job.html',
        backdrop: 'static',
        size: 'lg',
        keyboard: false,
        resolve: {
          job: function() {
            return job;
          },
          debug: function() {
            if (debug) {
              return debug;
            } else {
              return false;
            }
          }
        },
        controller: 'wdSegmentCtrl'
      });
    };
  }).controller('wdSegmentCtrl', function($scope, wdInterfaceApi, wdConfirm, $http, $log, job, debug) {
    var submit;
    $log.debug("Job : " + JSON.stringify(job));
    $scope.id = job.id.$oid;
    $scope.t_id = job.t_id;
    $scope.total = job.count;
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
        $log.info("Got result: " + res);
        return $scope.$close(true);
      });
    };
  });

}).call(this);

//# sourceMappingURL=services.js.map
