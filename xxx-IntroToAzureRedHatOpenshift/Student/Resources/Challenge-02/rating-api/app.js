require('dotenv').config();
var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
const mongoose = require('mongoose');

var app = express();

app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  next();
});

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

require('./models/mongo/item');
require('./models/mongo/rate');
require('./models/mongo/site');

mongoose.Promise = global.Promise;

const connectOptions = {
  useMongoClient: true,
  autoIndex: false, // Don't build indexes
  reconnectTries: Number.MAX_VALUE, // Never stop trying to reconnect
  reconnectInterval: 500, // Reconnect every 500ms
  poolSize: 10, // Maintain up to 10 socket connections
  connectTimeoutMS: 10000, // Give up initial connection after 10 seconds
  socketTimeoutMS: 45000, // Close sockets after 45 seconds of inactivity
};

if(process.env.MONGODB_URI == undefined) {
  console.error("process.env.MONGODB_URI is undefined. You need to provide the mongoDB connection information.");
}

var promise = mongoose.connect(process.env.MONGODB_URI, connectOptions);
promise.then(
  () => {
    console.dir('CONNECTED TO ' + process.env.MONGODB_URI);

    var Rate = mongoose.model("Rate");
    var Item = mongoose.model("Item");
    var Site = mongoose.model("Site");

    // Check if the items are empty, insert mock data
    Item.count({}, function(err, c) {
      if(c == 0) {
        console.dir('No items found in the database. Loading data.');
        var itemsMock = require('./data/items.json');
        Item.collection.insertMany(itemsMock, function(err,r) {
          if(err) {
            console.error('Error inserting items: ' + err);
          } else {
            console.dir('Items loaded.');
          }
        });
      } else {
        console.dir( c + ' items found in the database. Skipping loading data.');
      }
    });

    // Check if the sites are empty, insert mock data
    Site.count({}, function(err, c) {
      if(c == 0) {
        console.dir('No sites found in the database. Loading data.');
        var sitesMock = require('./data/sites.json');
        Site.collection.insertMany(sitesMock, function(err,r) {
          if(err) {
            console.error('Error inserting sites: ' + err);
          } else {
            console.dir('Sites loaded.');
          }
        });
      } else {
        console.dir( c + ' sites found in the database. Skipping loading data.');
      }
    });
    
  }
).catch(
  err => {
    console.error('ERROR: UNABLE TO CONNECT TO ' + process.env.MONGODB_URI);
    console.error('Make sure you have set the environment variable MONGODB_URI to the correct endpoint.');
    console.error(err.message);
  }
);

var items = require('./routes/items');
var index = require('./routes/index');

app.use('/', index);
app.use('/api', items);

app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

app.use(function(err, req, res, next) {
  res.locals.message = err.message;
  res.locals.error = err;

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
