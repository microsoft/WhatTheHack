const mongoose = require('mongoose'),
    Session = mongoose.model('Session');

exports.list = function(query, callback) {
    console.log("==== Load Sessions ====");
    Session.find(query).lean().exec(function(err, sessionsList) {
        if (err) {
            console.error(err);
            callback(err);
        } else {
            callback(null, sessionsList);
        }
    });
};