$(document).foundation();

var ViewModels = {} || ViewModels;
ViewModels.StatsViewModel = (function () {
  var exports = {};
  exports.taskId = ko.observable();
  exports.webTaskId =ko.observable();
  exports.hostName = ko.observable();
  exports.pid = ko.observable();
  exports.mem = ko.observable();
  exports.counters = ko.observable();
  exports.uptime = ko.observable();
  exports.load = function () {
    DataClient.Stats().loadStats().done(
      function (data) {
        exports.webTaskId(data.webTaskId);
        exports.taskId(data.taskId);
        exports.hostName(data.hostName);
        exports.pid(data.pid);
        exports.mem(JSON.stringify(data.mem));
        exports.counters(JSON.stringify(data.counters));
        exports.uptime(data.uptime);
      });
  };
  return exports;
}());

$(document).ready(function () {

  ko.applyBindings(ViewModels.StatsViewModel, document.getElementById('session--list'));
  ViewModels.StatsViewModel.load();

});
