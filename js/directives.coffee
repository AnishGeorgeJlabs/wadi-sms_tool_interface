###
  Works like a charm :D
  Tested on Sat, 15 Aug, 06:44 PM
###
angular.module('Wadi.directives', [])
.directive 'wdCoTypeSelect', () ->
  restrict: 'E'
  scope:
    model: '=model'
  templateUrl: './templates/directives/dir_co_type.html'

.directive 'wdRangeInput', () ->
  restrict: 'E'
  scope:
    label: '=label'
    model: '=model'
    showCoType: '=showCoType'
  templateUrl: './templates/directives/dir_range.html'
  replace: true
  controller: ($scope, $log) ->
    $scope.lt = "Less than"
    $scope.eq = "Equal to"
    $scope.gt = "More than"
    $scope.bw = "Between"

    $scope.data =
      op: ''
      min: 1
      max: 2

    compileResult = () ->
      $scope.model.value = switch $scope.data.op
        when '' then ''
        when $scope.bw then "#{$scope.bw} #{$scope.data.min} and #{$scope.data.max}"
        when $scope.eq then "#{$scope.data.min}"
        else "#{$scope.data.op} #{$scope.data.min}"

    $scope.$watchCollection(
      'data',
      (nVal, oVal) ->
        if nVal.min != oVal.min and nVal.min != null and nVal.min >= nVal.max
          $scope.data.max = $scope.data.min + 1
        if nVal.max != oVal.max and nVal.max != null and nVal.max <= nVal.min
          $scope.data.min = $scope.data.max - 1
        compileResult()
    )

    $scope.$watch(
      'model.value',
      (nVal, oVal) ->
        if oVal != '' and nVal == ''
          $scope.data.op = ''
    )

    # The genius touch, add this handler to the ng-blur of both inputs
    $scope.recover = () ->
      if $scope.data.min == null or $scope.data.min <= 0
        $scope.data.min = 1
      if $scope.data.max == null
        $scope.data.max = $scope.data.min + 1

.directive 'wdSelect', () ->
  restrict: 'E'
  scope:
    inputModel: '=inputModel'
    outputModel: '=outputModel'
    singleSelect: '=singleSelect'
  templateUrl: './templates/directives/dir_select.html'
  replace: true
  controller: ($scope, $log) ->
    $scope.options = [
      {name: 'option'}
    ]
    $scope.$watchCollection(
      'inputModel',
      (nVal, oVal) ->
        $scope.options = _.map(nVal.values, (v) ->
          res = {name: v}
          if ($scope.singleSelect and $scope.outputModel.value == v) or _.contains($scope.outputModel.value, v)
            res.selected = true
          res
        )
        if $scope.singleSelect and $scope.options.length > 0
          $scope.options[0].selected = true
    )

    $scope.$watchCollection(
      'selected',
      (nVal, oVal) ->
        res = _.map(nVal, (o) ->
          o.name
        )
        if $scope.singleSelect
          $scope.outputModel.value = res[0]
        else
          $scope.outputModel.value = res
    )

    $scope.$watchCollection(
      'outputModel',
      (nVal, oVal) ->
        if nVal.value != oVal.value
          if $scope.singleSelect
            nValues = [nVal.value]
          else
            nValues = nVal.value

          _.each($scope.options, (v, k) ->
            v.selected = _.contains(nValues, v.name)
          )
    )
###
.directive 'wdHierachySelect', () ->
  restrict: 'E'
  scope:
    inputModel: '=inputModel'
    outputModel: '=outputModel'
  templateUrl: './templates/directives/dir_hierarchy_select.html'
  controller: ($scope, $log) ->
    $scope.dynamicInput = {}
    updateInput = () ->
      $scope.dynamicInput = {
        name: $scope.inputModel.name
        values: $scope.inputModel.valueObj[$scope.selectedOpt]
        co_type: $scope.inputModel.co_type
      }
    updateInput()

    $scope.$watchCollection(
      'inputModel',
      (nVal, oVal) ->
        updateInput()
    )
    $scope.$watch(
      'selectedOpt',
      () ->
        updateInput()
    )
###
