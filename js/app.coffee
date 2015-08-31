###
  Wadi sms tool web interface
###

angular.module('Wadi', ['ui.router', 'ui.select', 'ui.bootstrap', 'ngSanitize', 'isteven-multi-select',
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
  )
  .state('test',
    templateUrl: './templates/view_test.html'
    controller: 'TestCtrl'
    url: '/test'
  )
