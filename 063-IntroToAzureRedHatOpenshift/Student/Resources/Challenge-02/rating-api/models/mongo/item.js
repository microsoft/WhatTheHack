var mongoose = require('mongoose');

var itemSchema = new mongoose.Schema({
    uid: Number,
    name: String,
    img: String
});

mongoose.model('Item', itemSchema, 'items');