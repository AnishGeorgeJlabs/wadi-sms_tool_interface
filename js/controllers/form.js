// Generated by CoffeeScript 1.9.3

/*
  Just the form controller
 */

(function() {
  angular.module('Wadi.controllers.form', []).controller('FormCtrl', function($scope, $state, $log, $http, $modal) {
    var cleanObj, configureForm;
    $scope.checkLogin = function() {
      $log.info("Checking login status at FormCtrl");
      if (!$scope.$parent.checkLogin()) {
        return $state.go('login');
      }
    };
    $scope.checkLogin();
    $scope.submitting = false;
    $http.get('http://45.55.72.208/wadi/interface/form').success(function(data) {
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
    $scope.debug = function(ev) {
      if (ev.keyCode === 13) {
        alert("Got it");
        ev.stopPropagation();
        return ev.preventDefault();
      }
    };
    $scope.campaign = {
      text: {
        arabic: '',
        english: ''
      },
      datetime: null
    };
    $scope.misc = {
      name: 'Untitled',
      description: '',
      debug: false
    };
    $scope.submit = function() {
      var dt, resM, resR, resS, result, target_config;
      $scope.submitting = true;
      resM = cleanObj($scope.selectedMulti);
      resS = cleanObj($scope.selectedSingle);
      resR = cleanObj($scope.selectedRange);
      target_config = _.extend({}, resS, resM, resR);
      dt = moment($scope.campaign.datetime).format("MM/DD/YYYY HH:mm").split(" ");
      $scope.campaign.date = dt[0];
      $scope.campaign.time = dt[1];
      result = {
        target_config: target_config,
        campaign_config: $scope.campaign,
        debug: $scope.misc.debug,
        name: $scope.misc.name,
        description: $scope.misc.description
      };
      $log.info("Final submission: " + JSON.stringify(result));
      return $http.post('http://45.55.72.208/wadi/interface/post', result).success(function(res) {
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
          templateUrl: 'templates/modal_submission.html'
        });
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
