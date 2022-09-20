'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const config = require('./config/config');
const mongoose = require('mongoose');
const chalk = require('chalk');

const port = 3001;
mongoose.connect(config.appSettings.db, { useNewUrlParser: true, useUnifiedTopology: true }, function (err) {
    if (err) {
        console.error(chalk.red('Could not connect to MongoDB!'));
        console.log(chalk.red(err));
        mongoose.connection.close();
        process.exit(-1);
    } else {
        console.log('Connected to MongoDB');
    }
});

require('./models/session.model');
require('./models/speakers.model');
const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Content-Type");
    res.header("Access-Control-Allow-Methods", "GET, PUT, POST");
    return next();
});
const routes = require('./routes');

routes(app);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    const err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function (err, req, res, next) {
        res.status(err.status || 500);
        res.send({
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function (err, req, res, next) {
    res.status(err.status || 500);
    res.send({
        message: err.message,
        error: {}
    });
});

const server = app.listen(port, () => {
    console.log(`Listening on port ${port}`);
});