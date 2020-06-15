var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var SessionSchema = new Schema({
    _id: {
        type: String
    },
    abstract: {
        type: String
    },
    date: {
        type: String
    },
    endTime: {
        type: Date
    },
    eventName: {
        type: String
    },
    hidden: {
        type: Boolean
    },
    roomID: {
        type: Number
    },
    roomName: {
        type: String
    },
    sessionID: {
        type: Number
    },
    sessioncode: {
        type: String
    },
    speakerNames: [{
        type: String
    }],
    speakers: [{
        type: String
    }],
    startTime: {
        type: Date
    },
    timeSlot: {
        type: Number
    },
    title: {
        type: String
    },
    trackNames: [{
        type: String
    }],
    tracks: [{
        type: String
    }]
});

module.exports = mongoose.model('Session', SessionSchema);