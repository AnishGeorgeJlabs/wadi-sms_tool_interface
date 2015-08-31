###
  Works like a charm :D
  Tested on Sat, 15 Aug, 06:44 PM
###
angular.module('Wadi.directives', [])
.directive 'wdCoTypeSelect', () ->
  restrict: 'E'
  scope:
    model: '=model'
  templateUrl: './templates/dir_co_type.html'

.directive 'wdRangeInput', () ->
  restrict: 'E'
  scope:
    label: '=label'
    model: '=model'
    showCoType: '=showCoType'
  templateUrl: './templates/dir_range.html'
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
  templateUrl: './templates/dir_select.html'
  replace: true
  controller: ($scope, $log) ->
    $scope.options = [
      {name: 'option'}
    ]
    $scope.$watchCollection(
      'inputModel',
      (nVal, oVal) ->
        $log.info "Directive got data: "+JSON.stringify(nVal)
        $scope.options = _.map(nVal.values, (v) ->
          res = {name: v}
          if _.contains($scope.outputModel.value, v)
            res.selected = true
          res
        )
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