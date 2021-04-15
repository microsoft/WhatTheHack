$(document).foundation();

var ViewModels = {} || ViewModels;
ViewModels.SessionsViewModel = (function () {
  var exports = {};
  var speakersList = {};
  exports.allSessions = ko.observableArray([]);
  exports.filteredSessions = ko.observableArray([]);
  exports.load = function () {
    DataClient.SpeakersCatalog().getSpeakersList().done(
      function (data) {
        speakersList = data;
      });

    DataClient.SessionsCatalog().getFullSessionList().done(
      function (data) {
        var sessionSpeakers = [];
        $.each(data, function (index, value) {
          $.each(value.speakers, function (speakerIndex, speakerId) {
            var speaker = $.grep(speakersList, function (n) {
              return n.speakerID == speakerId;
            });
            sessionSpeakers.push(speaker[0]);
          });
          value.speakersObj = sessionSpeakers;
          sessionSpeakers = [];
        });
        exports.allSessions(data);
        exports.filterSessionsByCategory("*");
      });
  };

  exports.filterSessionsByCategory = function (category) {
    var filteredList = [];

    if (category === "*") {
      filteredList = exports.allSessions();
    }
    else {
      filteredList = exports.allSessions().filter(function (item) {
        return (item.title.search(new RegExp(category, "i")) > -1
        || JSON.stringify(item.speakerNames).search(new RegExp(category, "i")) > -1
        || item.abstract.search(new RegExp(category, "i")) > -1);
      });
    }

    exports.filteredSessions(filteredList);
  };

  return exports;
}());

$(document).ready(function () {

  $("a.primary-button, .top-nav-bar .right a").click(
    function () {
      var sh = new ScrollHelper();
      sh.scrollTo(this.hash);
    });

  $("nav.top-bar ul li a").click(
    function () {
      var sh = new ScrollHelper();
      sh.scrollTo(this.hash);
    });

  $(".session-filter li a").click(function (e) {
    e.preventDefault();
    $(".session-filter li a").removeClass("selected");
    $(this).addClass("selected");

    $(".search .searchBox").val("");
    $(".resetSearch").hide();

    ViewModels.SessionsViewModel.filterSessionsByCategory($(this).attr("data-filter"));
  });

  $(".search input[type='button']").click(function (e) {
    e.preventDefault();
    $(".resetSearch").show();

    $(".session-filter li a").removeClass("selected");

    ViewModels.SessionsViewModel.filterSessionsByCategory($(".search .searchBox").val());
  });

  $(".resetSearch").click(function (e) {
    e.preventDefault();
    ViewModels.SessionsViewModel.filterSessionsByCategory("*");
    $(".search .searchBox").val("");
    $(".resetSearch").hide();
  });

  $(".resetSearch").hide();


  ko.applyBindings(ViewModels.SessionsViewModel, document.getElementById('session--list'));
  ViewModels.SessionsViewModel.load();

});
