###
  Wadi sms tool web interface
###

angular.module('Wadi', ['ui.router', 'ui.select', 'ui.bootstrap', 'ngSanitize', 'isteven-multi-select', 'ngFileUpload', 'ngAnimate',
                        'Wadi.controllers.form', 'Wadi.controllers.main', 'Wadi.controllers.block_list', 'Wadi.controllers.dashboard'
                        'Wadi.directives', 'Wadi.constants', 'Wadi.services'])

.config ($stateProvider, $urlRouterProvider, uiSelectConfig, $provide) ->
  uiSelectConfig.theme = 'bootstrap'
  $stateProvider
  .state('login',
    templateUrl: './templates/views/view_login.html'
    controller: 'LoginCtrl'
  )
  .state('form',
    templateUrl: './templates/views/view_form.html'
    controller: 'FormCtrl'
    url: '/form'
  )
  .state('dashboard',
    templateUrl: './templates/views/view_dashboard.html'
    controller: 'DashboardCtrl'
    url: '/dashboard'
  )
  .state('block_list',
    templateUrl: './templates/views/view_block_list.html'
    controller: 'BlockListCtrl'
    url: './block_list'
  )
  .state('test',
    templateUrl: './templates/views/view_test.html'
    controller: 'TestCtrl'
    url: '/test'
  )

  $provide.decorator('accordionGroupDirective', ($delegate) ->
    directive = $delegate[0]
    directive.templateUrl = "./templates/directives/my_accordion.html"
    $delegate
  )
