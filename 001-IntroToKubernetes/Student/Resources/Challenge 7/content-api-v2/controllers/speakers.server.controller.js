const mongoose = require('mongoose'),
    Speaker = mongoose.model('Speaker');

exports.list = function(query, callback) {
    console.log("==== Load Speakers ====");
    Speaker.find(query).lean().exec(function(err, speakersList) {
        if (err) {
            callback(err);
        } else {
            callback(null, speakersList);
        }
    });
};