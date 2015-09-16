// Generated by CoffeeScript 1.9.3

/*
  Wadi sms tool web interface
 */

(function() {
  angular.module('Wadi', ['ui.router', 'ui.select', 'ui.bootstrap', 'ngSanitize', 'isteven-multi-select', 'ngFileUpload', 'ngAnimate', 'Wadi.controllers.form', 'Wadi.controllers.main', 'Wadi.controllers.block_list', 'Wadi.controllers.dashboard', 'Wadi.controllers.segments', 'Wadi.controllers.external', 'Wadi.directives', 'Wadi.constants', 'Wadi.services']).config(function($stateProvider, $urlRouterProvider, uiSelectConfig, $provide) {
    uiSelectConfig.theme = 'bootstrap';
    $stateProvider.state('login', {
      templateUrl: './templates/views/view_login.html',
      controller: 'LoginCtrl'
    }).state('form', {
      templateUrl: './templates/views/view_form.html',
      controller: 'FormCtrl',
      url: '/form'
    }).state('dashboard', {
      templateUrl: './templates/views/view_dashboard.html',
      controller: 'DashboardCtrl',
      url: '/dashboard'
    }).state('block_list', {
      templateUrl: './templates/views/view_block_list.html',
      controller: 'BlockListCtrl',
      url: '/block_list'
    }).state('external_data', {
      templateUrl: './templates/views/view_external_data.html',
      controller: 'ExternalDataCtrl',
      url: '/external'
    }).state('test', {
      templateUrl: './templates/views/view_test.html',
      controller: 'TestCtrl',
      url: '/test'
    });
    return $provide.decorator('accordionGroupDirective', function($delegate) {
      var directive;
      directive = $delegate[0];
      directive.templateUrl = "./templates/directives/my_accordion.html";
      return $delegate;
    });
  });

}).call(this);

//# sourceMappingURL=app.js.map
