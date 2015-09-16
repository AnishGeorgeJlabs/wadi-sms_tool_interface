// Generated by CoffeeScript 1.9.3
(function() {
  var base, base_api_url, block_list_url;

  base = "http://45.55.72.208/wadi/";

  base_api_url = base + "interface/";

  block_list_url = base + "block_list/";

  angular.module('Wadi.constants', []).constant('wdLinks', {
    scheduling_sheet: "https://docs.google.com/spreadsheets/d/144fuYSOgi8md4n2Ezoj9yNMi6AigoXrkHA9rWIF0EDw/edit",
    docs: "http://45.55.72.208/interface/wadi/docs.html"
  }).constant('wdInterfaceApi', {
    new_job: base_api_url + "job/new",
    new_segment: base_api_url + "job/segment/new",
    test_message: base_api_url + "job/testing_message",
    cancel_job: base_api_url + "job/cancel",
    jobs: base_api_url + "jobs",
    segment_jobs: base_api_url + "job/segments",
    segment_jobs_external: base_api_url + "external_segments",
    external_data_counts: base + "external_data/count",
    form: base_api_url + "form",
    login: base_api_url + "login"
  }).constant('wdBlockApi', {
    upload: block_list_url + "upload",
    count: block_list_url + "count"
  });

}).call(this);

//# sourceMappingURL=constants.js.map
