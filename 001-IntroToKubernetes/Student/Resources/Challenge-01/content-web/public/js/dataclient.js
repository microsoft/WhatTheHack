var DataClient = DataClient || {};
var trackIds = ["136", "137", "138"];
var trackValues = ["Architect", "IoT", "Security"];

DataClient.Stats = function () {
  var exports = {};
  exports.loadStats = function () {
    var deferred = $.Deferred();
    $.get("/api/stats", function (stats, textStatus, jqXhr) {
      deferred.resolve(stats);
    }).fail(function (xhr, status, error) {
      deferred.reject(error);
    });
    return deferred.promise();
  };
  return exports;
};

DataClient.SessionsCatalog = function () {
  var exports = {};
  exports.getFullSessionList = function () {
    var deferred = $.Deferred();
    $.get("/api/sessions",
      function (sessions, textStatus, jqXhr) {
        if (sessions) {
          var filteredOutHiddenSessions = sessions.filter(function (item) {
            var includeSession = false;
            var track;

            for (var i = 0; i < item.tracks.length; i++) {
              track = item.tracks[i];
              if (trackIds.indexOf(track) != -1) {
                includeSession = true;
              }
            }
            return includeSession;
          });
          filteredOutHiddenSessions = sessions.filter(function (item) {
            return !(item.sessioncode !== "" && /^(PRECON|POSTCON).*/.test(item.sessioncode));
          });
          deferred.resolve(filteredOutHiddenSessions);
        }
      })
      .fail(function (xhr, status, error) {
        deferred.reject(error);
      });
    return deferred.promise();
  };

  return exports;
};

DataClient.SpeakersCatalog = function () {
  var exports = {};
  exports.getFullSpeakersList = function () {
    var deferred = $.Deferred();
    $.get("/api/speakers",
      function (speakers, textStatus, jqXhr) {
        if (speakers) {
          deferred.resolve(speakers);
        }
      }
    ).fail(function (xhr, status, error) {
      deferred.reject(error);
    });

    return deferred.promise();
  };
  exports.getSpeakersList = function () {
    var deferred = $.Deferred();
    $.get("/api/speakers",
      function (speakers, textStatus, jqXhr) {
        if (speakers) {
          var filteredOutHiddenSpeakers = speakers.filter(function (item) {
            return !item.hidden;
          });
          deferred.resolve(filteredOutHiddenSpeakers);
        }
      }
    ).fail(function (xhr, status, error) {
      deferred.reject(error);
    });

    return deferred.promise();
  };
  return exports;
};

DataClient.SpeakerDetailsCatalog = function (name, technology) {
  var exports = {};
  exports.getFullSpeakersList = function () {
    var deferred = $.Deferred();
    $.get("/speakerdetails/",
      function (speakers, textStatus, jqXhr) {
        if (speakers) {
          var filteredOutHiddenSpeakers = speakers.filter(function (item) {
            var includeSpeaker = false;
            var track;

            for (var i = 0; i < item.tracks.length; i++) {
              track = item.tracks[i];
              // include Arch, IoT, Security tracks
              if (trackIds.indexOf(track) != -1) {
                includeSpeaker = true;
              }
            }

            return includeSpeaker;

          });
          deferred.resolve(filteredOutHiddenSpeakers);
        }
      }
    ).fail(function (xhr, status, error) {
      deferred.reject(error);
    });

    return deferred.promise();
  };

  return exports;
};
