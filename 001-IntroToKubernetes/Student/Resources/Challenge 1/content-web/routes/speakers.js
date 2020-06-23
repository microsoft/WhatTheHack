'use strict';

var express = require('express');
var dataAccess = require('../data-access');

var router = express.Router();

// get all
router.get('/', function(req, res, next) {
    dataAccess.getSpeakers(function(err, data) {
        if (err) {
            return next(err);
        }
        res.render('speaker-list', {
            title: 'The Conference Speakers',
            data: data
        });
    });
});

module.exports = router;