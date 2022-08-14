$(document).foundation();

var ViewModels = {} || ViewModels;
ViewModels.SpeakersViewModel = (function () {
  var exports = {};

  exports.allSpeakers = ko.observableArray([]);
  exports.filteredSpeakers = ko.observableArray([]);

  exports.load = function (callback) {
    DataClient.SpeakersCatalog().getFullSpeakersList().done(
      function (data) {
        exports.allSpeakers(data);
        exports.filterSpeakersBySearchTerms("*");
        callback();
      });
  };

  exports.filterSpeakersBySearchTerms = function (searchTerms) {
    var filteredList = [];

    if (searchTerms === "*") {
      filteredList = exports.allSpeakers();
    }
    else {
      filteredList = exports.allSpeakers().filter(function (item) {
        return (item.title.search(new RegExp(searchTerms, "i")) > -1
          || item.first.search(new RegExp(searchTerms, "i")) > -1
          || item.last.search(new RegExp(searchTerms, "i")) > -1
          || item.company.search(new RegExp(searchTerms, "i")) > -1
          || item.bio.search(new RegExp(searchTerms, "i")) > -1
        );
      });
    }

    exports.filteredSpeakers(filteredList);
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

  $(".search input[type='button']").click(function (e) {
    e.preventDefault();
    //$(".session-filter li a").removeClass("selected");
    //$(this).addClass("selected");
    $(".resetSearch").show();
    ViewModels.SpeakersViewModel.filterSpeakersBySearchTerms($(".search .searchBox").val());
  });

  $(".resetSearch").click(function (e) {
    e.preventDefault();
    //$(".session-filter li a").removeClass("selected");
    //$(this).addClass("selected");
    ViewModels.SpeakersViewModel.filterSpeakersBySearchTerms("*");
    $(".search .searchBox").val("");
    $(".resetSearch").hide();
  });

  $(".resetSearch").hide();


  ko.applyBindings(ViewModels.SpeakersViewModel, document.getElementById('speakers-list'));
  ViewModels.SpeakersViewModel.load(function () {
    // prevent clicking of links within speaker bio
    $(".speakers-list a[href^='http']").removeAttr("href")
  });

});
