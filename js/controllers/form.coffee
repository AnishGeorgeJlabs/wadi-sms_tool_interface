###
  Just the form controller
###
angular.module('Wadi.controllers.form', [])
.controller 'FormCtrl', ($scope, $state, $log, $http, $modal) ->
  $scope.checkLogin = () ->
    $log.info "Checking login status at FormCtrl"
    if not $scope.$parent.checkLogin()
      $state.go('login')
  $scope.checkLogin()

  $scope.submitting = false

  $http.get 'http://45.55.72.208/wadi/interface/form'
  .success (data) ->
    $scope.loading = false
    configureForm(data)

  # ------- Target Configuration --------- #
  $scope.loading = true
  $scope.multi = {}
  $scope.single = {}
  $scope.range = {}

  $scope.selectedMulti = {}
  $scope.selectedSingle = {}
  $scope.selectedRange = {}

  configureForm = (mainData) ->
    for data in mainData
      if data.type == 'single'
        $scope.single[data.operation] = {name: data.pretty, values: data.values, co_type: data.co_type }
        $scope.selectedSingle[data.operation] = { value: '', co_type: 'required' }
      else if data.type == 'multi'
        $scope.multi[data.operation] = {name: data.pretty, values: data.values, co_type: data.co_type }
        $scope.selectedMulti[data.operation] = { value: [], co_type: 'required' }
      else if data.type == 'range'
        $scope.range[data.operation] = {name: data.pretty, co_type: data.co_type}
        $scope.selectedRange[data.operation] = { value: '', co_type: 'required' }

  cleanObj = (obj) ->
    _.pick obj, (val, key, o) ->
      val and val.value and val.value.length > 0

  # ------------------------------------- #

  $scope.campaign =
    text:
      arabic: ''
      english: ''
    datetime: null

  $scope.misc =
    name: 'Untitled'
    description: ''
    debug: false

  $scope.submit = () ->
    $scope.submitting = true
    resM = cleanObj($scope.selectedMulti)
    resS = cleanObj($scope.selectedSingle)
    resR = cleanObj($scope.selectedRange)
    target_config = _.extend({}, resS, resM, resR)

    dt = moment($scope.campaign.datetime).format("MM/DD/YYYY HH:mm").split(" ")
    $scope.campaign.date = dt[0]
    $scope.campaign.time = dt[1]

    result =
      target_config: target_config
      campaign_config: $scope.campaign
      debug: $scope.misc.debug
      name: $scope.misc.name
      description: $scope.misc.description

    $log.info "Final submission: "+JSON.stringify(result)


    $http.post('http://45.55.72.208/wadi/interface/post', result)
    .success (res) ->
      $log.debug "Submission result: "+JSON.stringify(res)
      $scope.submitting = false
      $modal.open(
        controller: ($scope, $modalInstance, wdLinks) ->
          $scope.result = res
          $scope.sheet_link = wdLinks.scheduling_sheet
          $scope.close = () ->
            $modalInstance.dismiss('ok')
        templateUrl: 'templates/modal_submission.html'
      )


  $scope.reset = () ->
    $scope.selectedMulti = _.mapObject($scope.selectedMulti, () -> { value: [], co_type: 'required' })
    $scope.selectedSingle = _.mapObject($scope.selectedSingle, () -> { value: '', co_type: 'required' })
    $scope.selectedRange = _.mapObject($scope.selectedRange, () -> { value: '', co_type: 'required' })
