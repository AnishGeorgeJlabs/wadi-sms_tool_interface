// Generated by CoffeeScript 1.9.3

/*
  Block list View form
 */

(function() {
  angular.module('Wadi.controllers.block_list', []).controller('BlockListCtrl', function($log, $scope, $state, Upload, $timeout, $http, wdBlockApi, wdToast) {
    if (!$scope.$parent.checkLogin()) {
      $state.go('login');
    }
    $scope.uploading = false;
    $scope.report = {};
    $http.get(wdBlockApi.count).success(function(data) {
      if (data.success) {
        return $scope.report.total_blocked = {
          email: data.email,
          phone: data.phone
        };
      }
    });

    /*
    $scope.report =
      blocked:
        email: 10
        phone: 30
      total_blocked:
        email: 1532
        phone: 591
     */
    $scope.submit = function() {
      if ($scope.blockForm.file.$valid && $scope.file && !$scope.file.$error) {
        return $scope.upload($scope.file);
      } else {
        return $log.debug("Didn't upload!!");
      }
    };
    return $scope.upload = function(file) {
      $scope.uploading = true;
      return Upload.upload({
        url: wdBlockApi.upload,
        file: file
      }).success(function(data) {
        $log.info("Got result: " + JSON.stringify(data));
        $scope.uploading = false;
        if (data.success) {
          wdToast("Block List added", "The block list was processed succfully and the given data added to the server", "success");
          $scope.report = {};
          if (data.blocked) {
            $scope.report.blocked = data.blocked;
          }
          if (data.total_blocked) {
            $scope.report.total_blocked = data.total_blocked;
          }
        } else {
          wdToast("Block List failed", "There was a problem processing the request, please check your file contents", "error");
        }
        return $timeout(function() {
          return $scope.message = null;
        }, 1000);
      });
    };
  });

}).call(this);

//# sourceMappingURL=block_list.js.map
