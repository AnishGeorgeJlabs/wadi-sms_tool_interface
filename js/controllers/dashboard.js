// Generated by CoffeeScript 1.9.3

/*
  Dashboard controller
 */

(function() {
  angular.module('Wadi.controllers.dashboard', []).controller('DashboardCtrl', function($scope, $state, $log, $http, $interval, wdInterfaceApi, wdConfirm, wdSegment, wdToast) {
    var periodicRefresh, refresh, store_job_data, store_segment_data;
    if (!$scope.$parent.checkLogin()) {
      $state.go('login');
    }
    $scope.tab = 'jobs';
    $scope.changeTabTo = function(tb) {
      return $scope.tab = tb;
    };
    $scope.isTab = function(tb) {
      return $scope.tab === tb;
    };
    store_job_data = function(dt) {
      return $scope.job_data = _.map(dt, function(obj) {
        obj._id = obj._id.$oid;
        obj.timestamp = obj.timestamp.$date;
        return obj;
      });
    };
    store_segment_data = function(dt) {
      return $scope.segment_data = _.map(dt, function(obj) {
        obj.ref_job = obj.ref_job.$oid;
        obj.timestamp = obj.timestamp.$date;
        return obj;
      });
    };
    refresh = function() {
      $http.get(wdInterfaceApi.jobs).success(function(data) {
        if (data.success) {
          return store_job_data(data.data);
        } else {
          return $log.warning("Problem fetching data: " + JSON.stringify(data));
        }
      });
      return $http.get(wdInterfaceApi.segment_jobs).success(function(data) {
        if (data.success) {
          return store_segment_data(data.data);
        } else {
          return $log.warning("Problem fetching segment data: " + JSON.stringify(data));
        }
      });
    };
    refresh();
    periodicRefresh = $interval(function() {
      return refresh();
    }, 10000);
    $scope.$on("$destroy", function() {
      return $interval.cancel(periodicRefresh);
    });
    $scope.confirmAndCancelJob = function(oid, t_id) {
      var full_message, message;
      if (!t_id) {
        message = "the given job?";
      } else {
        message = "Job " + t_id + "?";
      }
      full_message = "Are you sure you want to cancel " + message + "? This is an irreversible action!";
      return wdConfirm("Confirm cancellation", full_message).then(function(res) {
        if (res) {
          return $scope.cancelJob(oid, t_id);
        }
      });
    };
    $scope.cancelJob = function(oid, t_id) {
      var obj;
      obj = {
        id: oid
      };
      if (t_id !== void 0) {
        obj.t_id = t_id;
      }
      $log.debug("About to post: " + JSON.stringify(obj));
      return $http.post(wdInterfaceApi.cancel_job, obj).success(function(data) {
        if (data.success) {
          return wdToast("Job Cancellation", "The Job has been cancelled, the dashboard will refresh shortly", "info");
        }
      });
    };
    return $scope.segment = function(job) {
      return wdSegment(job).then(function(res) {
        if (res) {
          return wdToast("Success", "Successfully processed your request for segmentation, you should see the results in the sheet shortly", "success");
        }
      });
    };
  });

}).call(this);

//# sourceMappingURL=dashboard.js.map
