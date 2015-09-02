###
  Dashboard controller
###

angular.module('Wadi.controllers.dashboard', [])
.controller 'DashboardCtrl', ($scope, $state, $log, $http) ->
  if not $scope.$parent.checkLogin()
    $state.go 'login'

