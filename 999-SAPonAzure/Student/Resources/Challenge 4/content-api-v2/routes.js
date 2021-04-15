'use strict';

const appController = require('./controllers/app.server.controller');

const init = function (app) {
    app.get("/sessions", appController.sessionsGet);
    app.get("/speakers", appController.speakersGet);
    app.get("/stats", appController.statsGet);
    app.get("/", function (req, res) {
        res.status(200).send("");
    });
};

module.exports = init;