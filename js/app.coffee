###
  Wadi sms tool web interface
###

angular.module('Wadi', ['ui.router', 'ui.select', 'ui.bootstrap', 'ngSanitize', 'isteven-multi-select', 'ngFileUpload'
                        'Wadi.controllers.form', 'Wadi.controllers.main'
                        'Wadi.directives', 'Wadi.constants'])

.config ($stateProvider, $urlRouterProvider, uiSelectConfig) ->
  uiSelectConfig.theme = 'bootstrap'
  $stateProvider
  .state('login',
    templateUrl: './templates/view_login.html'
    controller: 'LoginCtrl'
  )
  .state('form',
    templateUrl: './templates/view_main.html'
    controller: 'FormCtrl'
    url: '/form'
  )
  .state('dashboard',
    templateUrl: './templates/view_dashboard.html'
    url: '/dashboard'
  )
  .state('block_list',
    templateUrl: './templates/view_block_list.html'
    url: './block_list'
  )
  .state('test',
    templateUrl: './templates/view_test.html'
    controller: 'TestCtrl'
    url: '/test'
  )
