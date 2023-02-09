var mongoose = require('mongoose');

var siteSchema = new mongoose.Schema({
    name: String,
    shortCode: String,
    pages: mongoose.Schema.Types.Mixed,
});

mongoose.model('Site', siteSchema, 'sites');