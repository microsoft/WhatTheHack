const mongoose = require('mongoose');
const config = require('./config/config');
const chalk = require('chalk');
const async = require('async');

mongoose.connect(config.appSettings.db, { useNewUrlParser: true, useUnifiedTopology: true }, function (err) {
    if (err) {
        console.error(chalk.red('Could not connect to MongoDB!'));
        console.log(chalk.red(err));
        mongoose.connection.close();
        process.exit(-1);
    } else {
        console.log('Connected to MongoDb');
    }
});

require('./models/session.model');
const Session = mongoose.model('Session');

require('./models/speakers.model');
const Speaker = mongoose.model('Speaker');

async.waterfall([
    function (callback) {
        console.log('Clean Sessions table');
        Session.remove({}, function (err) {
            if (err) {
                callback(err);
            } else {
                console.log(chalk.green('All Sessions deleted'));
                callback(null);
            }
        })
    },
    function (callback) {
        console.log('Load sessions from JSON file');
        const sessionsTemplate = require('./json/sessions');
        const createSession = function (object, itemCallback) {
            const session = new Session(object);
            session.save(function (err) {
                if (err) {
                    itemCallback(err);
                } else {
                    console.log(chalk.green('Session saved successfully'));
                    itemCallback(null);
                }
            });
        };
        async.each(sessionsTemplate, createSession, callback)
    },
    function (callback) {
        console.log('Clean Speakers table');
        Speaker.remove({}, function (err) {
            if (err) {
                callback(err);
            } else {
                console.log(chalk.green('All Speakers deleted'));
                callback(null);
            }
        });
    },
    function (callback) {
        console.log('Load Speakers from JSON file');
        const speakersTemplate = require('./json/speakers');
        const createSpeaker = function (object, itemCallback) {
            const speaker = new Speaker(object);
            speaker.save(function (err) {
                if (err) {
                    itemCallback(err);
                } else {
                    console.log(chalk.green('Speaker saved successfully'));
                    itemCallback(null);
                }
            });
        };
        async.each(speakersTemplate, createSpeaker, callback)
    }
], function (err) {
    if (err) {
        console.error(chalk.red(err));
    }
    mongoose.connection.close();
});