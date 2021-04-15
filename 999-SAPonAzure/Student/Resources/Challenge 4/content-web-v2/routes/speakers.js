'use strict';

const express = require('express');
const dataAccess = require('../data-access');

const router = express.Router();

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