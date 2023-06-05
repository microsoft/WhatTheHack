var mongoose = require('mongoose');
var Hero = mongoose.model('Item');

var rateSchema = new mongoose.Schema({
    rating: { type: Number, min: 0, max: 5, default: 0 },
    timestamp: { type: Date, default: Date.now },
    raterIp: String,
    itemRated: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Item' }]
});

mongoose.model('Rate', rateSchema, 'ratings');