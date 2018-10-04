const sessionController = require('./sessions.server.controller');
const speakerController = require('./speakers.server.controller');

const counters = {
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

exports.speakersGet = function(req, res) {
    speakerController.list({}, function(err, speakers) {
        counters.speakers++;
        res.json(speakers);
    });
};

exports.statsGet = function(req, res) {
    counters.stats++;
    res.json(stats());
};
exports.sessionsGet = function(req, res) {
    sessionController.list({}, function(err, sessions) {
        counters.sessions++;
        res.json(sessions);
    });
};