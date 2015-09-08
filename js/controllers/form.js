// Generated by CoffeeScript 1.9.3

/*
  Just the form controller
 */

(function() {
  angular.module('Wadi.controllers.form', []).controller('FormCtrl', function($scope, $state, $log, $http, $modal, $filter, wdInterfaceApi, wdConfirm, wdToast) {
    var cleanObj, configureForm, repeat;
    $scope.checkLogin = function() {
      $log.info("Checking login status at FormCtrl");
      if (!$scope.$parent.checkLogin()) {
        return $state.go('login');
      }
    };
    $scope.checkLogin();
    $scope.submitting = false;
    $http.get(wdInterfaceApi.form).success(function(data) {
      $scope.loading = false;
      return configureForm(data);
    });
    $scope.loading = true;
    $scope.multi = {};
    $scope.single = {};
    $scope.range = {};
    $scope.selectedMulti = {};
    $scope.selectedSingle = {};
    $scope.selectedRange = {};
    configureForm = function(mainData) {
      var data, i, len, results;
      results = [];
      for (i = 0, len = mainData.length; i < len; i++) {
        data = mainData[i];
        if (data.type === 'single') {
          $scope.single[data.operation] = {
            name: data.pretty,
            values: data.values,
            co_type: data.co_type
          };
          results.push($scope.selectedSingle[data.operation] = {
            value: '',
            co_type: 'required'
          });
        } else if (data.type === 'multi') {
          $scope.multi[data.operation] = {
            name: data.pretty,
            values: data.values,
            co_type: data.co_type
          };
          results.push($scope.selectedMulti[data.operation] = {
            value: [],
            co_type: 'required'
          });
        } else if (data.type === 'range') {
          $scope.range[data.operation] = {
            name: data.pretty,
            co_type: data.co_type
          };
          results.push($scope.selectedRange[data.operation] = {
            value: '',
            co_type: 'required'
          });
        } else if (data.type === 'config') {
          $scope.config.repeat = data.repeat;
          results.push($scope.campaign.repeat = data.repeat[0]);
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    cleanObj = function(obj) {
      return _.pick(obj, function(val, key, o) {
        return val && val.value && val.value.length > 0;
      });
    };
    $scope.getMessage = function() {
      var dfilter, dt, end_day, res, start_day, tm;
      dfilter = $filter('date');
      dt = $scope.campaign.start_date;
      tm = $scope.campaign.time;
      start_day = dfilter(dt);
      end_day = dfilter($scope.campaign.end_date);
      res = "The campaign will execute " + (function() {
        switch ($scope.campaign.repeat) {
          case "Immediately":
            return "once, as soon as it is processed";
          case "Once":
            return "on " + start_day;
          case "Hourly":
            return "every " + dfilter(tm, 'h') + " hours at " + dfilter(tm, 'm') + " minutes";
          case "Daily":
            return "daily at " + dfilter(tm, 'hh:mm a');
          case "Weekly":
            return "every " + dfilter(dt, 'EEEE');
          case "Fortnightly":
            return "every other " + dfilter(dt, 'EEEE');
          case "Monthly":
            return "every month on " + dfilter(dt, 'dd');
          default:
            return "soon";
        }
      })();
      if ($scope.campaign.repeat !== 'Once' && $scope.campaign.repeat !== 'Immediately') {
        res += " starting " + start_day;
        if ($scope.campaign.end_date) {
          res += " and will go on till " + end_day;
        }
        return res;
      } else {
        return res;
      }
    };
    $scope.minEndDate = function() {
      return $scope.campaign.end_date;
    };
    $scope.config = repeat = [];
    $scope.campaign = {
      text: {
        arabic: '',
        english: ''
      },
      start_date: null,
      end_date: null,
      time: null,
      repeat: ''
    };
    $scope.misc = {
      name: 'Untitled',
      description: '',
      debug: false,
      segmented: false
    };
    $scope.confirmAndSubmit = function() {
      if ($scope.jobForm.$invalid) {
        _.each(['english', 'arabic', 'start_date', 'time', 'end_date'], function(key) {
          if ($scope.jobForm[key].$invalid) {
            return $scope.jobForm[key].$setTouched();
          }
        });
        return;
      }
      return wdConfirm("Confirm submission", "Are you sure you want to submit this Job?").then(function(res) {
        if (res) {
          return $scope.submit();
        }
      });
    };
    $scope.submit = function() {
      var campaign_config, resM, resR, resS, result, target_config;
      $scope.submitting = true;
      resM = cleanObj($scope.selectedMulti);
      resS = cleanObj($scope.selectedSingle);
      resR = cleanObj($scope.selectedRange);
      target_config = _.extend({}, resS, resM, resR);
      campaign_config = _.mapObject($scope.campaign, function(val, key) {
        if (_.contains(['start_date', 'end_date', 'time'], key)) {
          return parseInt(moment(val).format("x"));
        } else {
          return val;
        }
      });
      result = {
        target_config: target_config,
        campaign_config: campaign_config,
        debug: $scope.misc.debug,
        segmented: $scope.misc.segmented,
        name: $scope.misc.name,
        description: $scope.misc.description
      };
      $log.info("Final submission: " + JSON.stringify(result));
      return $http.post(wdInterfaceApi.new_job, result).success(function(res) {
        $log.debug("Submission result: " + JSON.stringify(res));
        $scope.submitting = false;
        return $modal.open({
          controller: function($scope, $modalInstance, wdLinks) {
            $scope.result = res;
            $scope.sheet_link = wdLinks.scheduling_sheet;
            return $scope.close = function() {
              return $modalInstance.dismiss('ok');
            };
          },
          templateUrl: 'templates/modals/modal_submission.html'
        });
      });
    };
    $scope.confirmAndTestMessage = function() {
      var full_message;
      full_message = "Are you sure you want to send test messages to the selected numbers now?\n\nThe arabic sms content is: " + $scope.campaign.text.arabic + ".\n\nThe english sms content is: " + $scope.campaign.text.english + ".\n";
      return wdConfirm("Confirm test messaging", full_message, 'md').then(function(res) {
        if (res) {
          return $scope.testMessage();
        }
      });
    };
    $scope.testMessage = function() {
      return $http.post(wdInterfaceApi.test_message, {
        arabic: $scope.campaign.text.arabic,
        english: $scope.campaign.text.english
      }).success(function(data) {
        if (data.success) {
          return wdToast("Success", "Testing campaign has been scheduled successfully", "success");
        } else {
          return wdToast("Error on testing campaign", "Details: " + data.error, "error");
        }
      });
    };
    return $scope.reset = function() {
      $scope.selectedMulti = _.mapObject($scope.selectedMulti, function() {
        return {
          value: [],
          co_type: 'required'
        };
      });
      $scope.selectedSingle = _.mapObject($scope.selectedSingle, function() {
        return {
          value: '',
          co_type: 'required'
        };
      });
      return $scope.selectedRange = _.mapObject($scope.selectedRange, function() {
        return {
          value: '',
          co_type: 'required'
        };
      });
    };
  });

}).call(this);

//# sourceMappingURL=form.js.map
