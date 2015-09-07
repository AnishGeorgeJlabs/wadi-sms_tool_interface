// Generated by CoffeeScript 1.9.3

/*
  Dashboard controller
 */

(function() {
  angular.module('Wadi.controllers.dashboard', []).controller('DashboardCtrl', function($scope, $state, $log, $http, $interval, wdInterfaceApi, wdConfirm) {
    var periodicRefresh, refresh, sampleData, store_data;
    if (!$scope.$parent.checkLogin()) {
      $state.go('login');
    }
    sampleData = [
      {
        name: "Sample Job",
        status: "Data Loaded",
        t_id: 35,
        count: 610,
        file: "http://jlabs.co/downloadcsv.php?file=res_56.csv",
        _id: {
          $oid: "55e5587e21aaec7ec1b48247"
        },
        description: "This is a long sample description for the job. It has many additional information, which we are not interested in",
        timestamp: {
          $date: 1441113558632
        },
        start_date: "09/01/2015",
        repeat: "Hourly"
      }
    ];
    store_data = function(dt) {
      return $scope.data = _.map(dt, function(obj) {
        obj._id = obj._id.$oid;
        obj.timestamp = obj.timestamp.$date;
        return obj;
      });
    };
    refresh = function() {
      return $http.get(wdInterfaceApi.jobs).success(function(data) {
        if (data.success) {
          return store_data(data.data);
        } else {
          return $log.warning("Problem fetching data: " + JSON.stringify(data));
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
    return $scope.cancelJob = function(oid, t_id) {
      var obj;
      obj = {
        id: oid
      };
      if (t_id !== void 0) {
        obj.t_id = t_id;
      }
      $log.debug("About to post: " + JSON.stringify(obj));
      return $http.post(wdInterfaceApi.cancel_job, obj).success(function(data) {
        return $log.info("Job canceled successfully: " + JSON.stringify(data));
      });
    };
  });

}).call(this);

//# sourceMappingURL=dashboard.js.map
