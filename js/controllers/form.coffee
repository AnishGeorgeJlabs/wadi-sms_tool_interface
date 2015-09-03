###
  Just the form controller
###
angular.module('Wadi.controllers.form', [])
.controller 'FormCtrl', ($scope, $state, $log, $http, $modal, $filter) ->
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
      else if data.type == 'config'
        $scope.config.repeat = data.repeat
        $scope.campaign.repeat = data.repeat[0]

  cleanObj = (obj) ->
    _.pick obj, (val, key, o) ->
      val and val.value and val.value.length > 0

  # ------------------------------------- #
  $scope.getMessage = () ->
    dfilter = $filter('date')
    dt = $scope.campaign.start_date
    tm = $scope.campaign.time
    start_day = dfilter(dt)
    end_day = dfilter($scope.campaign.end_date)

    res = "The campaign will execute " +
    switch $scope.campaign.repeat
      when "Immediately" then "once, as soon as it is processed"
      when "Once" then "on #{start_day}"
      when "Hourly" then "every "+dfilter(tm, 'h')+" hours at "+dfilter(tm, 'm')+" minutes"
      when "Daily" then "daily at "+dfilter(tm, 'hh:mm a')
      when "Weekly" then "every "+dfilter(dt, 'EEEE')
      when "Fortnightly" then "every other "+dfilter(dt, 'EEEE')
      when "Monthly" then "every month on "+dfilter(dt, 'dd')
      else "soon"
    if $scope.campaign.repeat != 'Once' and $scope.campaign.repeat != 'Immediately'
      res += " starting #{start_day}"
      if $scope.campaign.end_date
        res += " and will go on till #{end_day}"
      res
    else
      res

  $scope.config =
    repeat = []

  $scope.campaign =
    text:
      arabic: ''
      english: ''
    start_date: null
    end_date: null
    time: null
    repeat: ''

  $scope.misc =
    name: 'Untitled'
    description: ''
    debug: false

  $scope.submit = () ->
    if not confirm("Are you sure you want to submit?")
      return
    $scope.submitting = true
    resM = cleanObj($scope.selectedMulti)
    resS = cleanObj($scope.selectedSingle)
    resR = cleanObj($scope.selectedRange)
    target_config = _.extend({}, resS, resM, resR)

    campaign_config = _.mapObject($scope.campaign, (val, key) ->
      if _.contains(['start_date', 'end_date', 'time'], key)
        return parseInt(moment(val).format("x"))
      else
        return val
    )

    result =
      target_config: target_config
      campaign_config: campaign_config
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
        templateUrl: 'templates/modals/modal_submission.html'
      )

  $scope.testMessage = () ->
    if not confirm("Are you sure you want to send test messages now?")
      return

    $http.post("http://45.55.72.208/wadi/interface/post/test", {
      arabic: $scope.campaign.arabic
      english: $scope.campaign.english
    }).success (data) ->
      alert "Testing campaign has been scheduled successfully"
      $log.info "Got result from test message: "+JSON.stringify(data)

  $scope.reset = () ->
    $scope.selectedMulti = _.mapObject($scope.selectedMulti, () -> { value: [], co_type: 'required' })
    $scope.selectedSingle = _.mapObject($scope.selectedSingle, () -> { value: '', co_type: 'required' })
    $scope.selectedRange = _.mapObject($scope.selectedRange, () -> { value: '', co_type: 'required' })
