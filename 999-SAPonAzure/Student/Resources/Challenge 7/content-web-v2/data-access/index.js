'use strict';

/*
 get data from the service
 */

const request = require('request');

//TODO: Exercise 2 - Task 6 - Step 4
//const contentApiUrl = "http://localhost:3001";
const contentApiUrl = process.env.CONTENT_API_URL;

function getSessions(cb) {
    request(contentApiUrl + '/sessions', function(err, response, body) {
        if (err) {
            return cb(err);
        }
        const data = JSON.parse(body); // FRAGILE: ASSUME: valid JSON
        cb(null, data);
    });
}

function getSpeakers(cb) {
    request(contentApiUrl + '/speakers', function(err, response, body) {
        if (err) {
            return cb(err);
        }
        const data = JSON.parse(body); // FRAGILE: ASSUME: valid JSON
        cb(null, data);
    });
}

function stats(cb) {
    request(contentApiUrl + '/stats', function(err, response, body) {
        if (err) {
            return cb(err);
        }
        const data = JSON.parse(body);
        cb(null, data);
    });
}

module.exports = {
    getSessions: getSessions,
    getSpeakers: getSpeakers,
    stats: stats
};
