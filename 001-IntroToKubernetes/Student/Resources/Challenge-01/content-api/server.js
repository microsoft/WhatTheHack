'use strict';

var express = require('express');
var bodyParser = require('body-parser');
var routes = require('./routes');

var app = express();
var port = 3001;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
routes(app);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.send({
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.send({
    message: err.message,
    error: {}
  });
});

var server = app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});
