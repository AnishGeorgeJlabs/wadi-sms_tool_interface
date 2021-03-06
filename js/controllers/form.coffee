###
  Just the form controller
###
angular.module('Wadi.controllers.form', [])
.controller 'FormCtrl', ($scope, $state, $log, $http, $modal, $filter, wdInterfaceApi, wdConfirm, wdToast) ->
  $scope.checkLogin = () ->
    $log.info "Checking login status at FormCtrl"
    if not $scope.$parent.checkLogin()
      $state.go('login')
  $scope.checkLogin()

  $scope.submitting = false

  $http.get wdInterfaceApi.form
  .success (data) ->
    $scope.loading = false
    configureForm(data)

  # ------- Target Configuration --------- #
  $scope.loading = true
  $scope.multi = {}
  $scope.single = {}
  $scope.range = {}
  $scope.hierarchy = {}

  $scope.selectedMulti = {}
  $scope.selectedSingle = {}
  $scope.selectedRange = {}
  $scope.selectedHierarchy = {}

  configureForm = (mainData) ->
    for data in mainData
      if data.type == 'single'
        $scope.single[data.operation] = {name: data.pretty, values: data.values, co_type: data.co_type }
        $scope.selectedSingle[data.operation] = { value: data.values[0], co_type: 'required' }
      else if data.type == 'multi'
        $scope.multi[data.operation] = {name: data.pretty, values: data.values, co_type: data.co_type }
        $scope.selectedMulti[data.operation] = { value: [], co_type: 'required' }
      else if data.type == 'range'
        $scope.range[data.operation] = {name: data.pretty, co_type: data.co_type}
        $scope.selectedRange[data.operation] = { value: '', co_type: 'required' }
      else if data.type == 'hierarchy'
        $scope.hierarchy[data.operation] = {pName: data.pretty, name: '', co_type: data.co_type, valueObj: data.valueObj }
        $scope.selectedHierarchy[data.operation] = { value: [], co_type: 'required'}
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

  $scope.minEndDate = () ->
    # moment($scope.campaign.start_date).add(1, 'd').format('YYYY-MM-DD')
    $scope.campaign.end_date

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
    segmented: false

  $scope.confirmAndSubmit = () ->
    if $scope.jobForm.$invalid
      _.each(['english', 'arabic', 'start_date', 'time', 'end_date'], (key) ->
        if $scope.jobForm[key].$invalid
          $scope.jobForm[key].$setTouched()
      )
      return

    wdConfirm("Confirm submission", "Are you sure you want to submit this Job?")
    .then (res) ->
      if res
        $scope.submit()


  $scope.submit = () ->
    $scope.submitting = true
    resM = cleanObj($scope.selectedMulti)
    resS = cleanObj($scope.selectedSingle)
    resR = cleanObj($scope.selectedRange)
    target_config = _.extend({}, resS, resM, resR)

    campaign_config = _.chain($scope.campaign)
      .pick( (v) ->
        v != null and v != ''
      )
      .mapObject( (val, key) ->
        if _(['start_date', 'end_date', 'time']).contains(key)
          return parseInt(moment(val).format("x"))
        else
          return val
      ).value()

    $log.debug "Final Campaign config: "+JSON.stringify(campaign_config)

    result =
      target_config: target_config
      campaign_config: campaign_config
      debug: $scope.misc.debug
      segmented: $scope.misc.segmented
      name: $scope.misc.name
      description: $scope.misc.description

    $log.info "Final submission: "+JSON.stringify(result)


    $http.post(wdInterfaceApi.new_job, result)
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

  $scope.confirmAndTestMessage = () ->
    full_message =
    """
    Are you sure you want to send test messages to the selected numbers now?\n
    The arabic sms content is: #{$scope.campaign.text.arabic}.\n
    The english sms content is: #{$scope.campaign.text.english}.\n
    """
    wdConfirm("Confirm test messaging", full_message, 'md')
    .then (res) ->
      $scope.testMessage() if res

  $scope.testMessage = () ->
    $http.post(wdInterfaceApi.test_message, {
      arabic: $scope.campaign.text.arabic
      english: $scope.campaign.text.english
    }).success (data) ->
      if data.success
        wdToast("Success", "Testing campaign has been scheduled successfully", "success")
      else
        wdToast("Error on testing campaign", "Details: "+data.error, "error")

  $scope.reset = () ->
    $scope.selectedMulti = _.mapObject($scope.selectedMulti, () -> { value: [], co_type: 'required' })
    $scope.selectedSingle = _.mapObject($scope.selectedSingle, (v, k) -> { value: $scope.single[k].values[0], co_type: 'required' })
    $scope.selectedRange = _.mapObject($scope.selectedRange, () -> { value: '', co_type: 'required' })
