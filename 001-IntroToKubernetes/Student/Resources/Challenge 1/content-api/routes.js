'use strict';

var sessions = require('./sessions'); // .json
var speakers = require('./speakers'); // .json

var counters = {
    stats: 0,
    speakers: 0,
    sessions: 0
};

function stats() {
    return {
        taskId: process.pid,
        hostName: process.env.HOSTNAME,
        pid: process.pid,
        mem: process.memoryUsage(),
        counters: counters,
        uptime: process.uptime()
    }
}

function sessionsGet(req, res) {
    counters.sessions++;
    res.json(sessions);
}

function speakersGet(req, res) {
    counters.speakers++;
    res.json(speakers);
}

function statsGet(req, res) {
    counters.stats++;
    res.json(stats());
}

var init = function(app) {
    app.get("/sessions", sessionsGet);
    app.get("/speakers", speakersGet);
    app.get("/stats", statsGet);
    app.get("/", function(req, res) {
        res.status(200).send("");
    });
};

module.exports = init;