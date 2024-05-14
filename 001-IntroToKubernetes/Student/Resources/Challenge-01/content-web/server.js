var express = require('express');
var routes = require('./routes');
var http = require('http');
var path = require('path');
var ejs = require('ejs');

var app = express();
// var swig = require('swig');

var dataAccess = require('./data-access/index');

var config = '';
if ('development' == app.get('env')) {
    config = require('./config/env/development');
    console.log("=== Using development environment === ");
} else {
    config = require('./config/env/production');
    console.log("=== Using production environment === ");
}

// all environments
app.set('port', 3000);
app.set('views', path.join(__dirname, 'public'));
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.set('view engine', 'html');
app.engine('html', ejs.renderFile);

if ('development' !== app.get('env')) {
    function ensureHttps(redirect) {
        return function(req, res, next) {
            if (req.headers['x-arr-ssl']) {
                next();
            } else if (redirect) {
                res.redirect('https://' + req.host + req.url);
            } else {
                res.send(404);
            }
        }
    }

    app.use(ensureHttps(true));
}

app.use(app.router);
app.use(express.static(path.join(__dirname, 'public'), { maxAge: 60000 }));

if ('development' == app.get('env')) {
    app.use(express.errorHandler());
}

app.get('/api/sessions', function(req, res) {
    dataAccess.getSessions(function(error, data) {
        if (error) {
            return res.status(500).send(error);
        } else {
            return res.status(200).send(data);
        }
    });
});

app.get('/api/speakers', function(req, res) {
    dataAccess.getSpeakers(function(error, data) {
        if (error) {
            return res.status(500).send(error);
        } else {
            return res.status(200).send(data);
        }
    });
});

app.get('/speakers/:technology/:name', function(req, res) {

    var name = req.params.name,
        technology = req.params.technology;

    res.render('speakerdetails', { name: name, technology: technology });

});

app.get('/speakerdetails/', function(req, res) {
    dataAccess.getSpeakers(function(error, data) {
        if (error) {
            return res.status(500).send(error);
        } else {
            return res.status(200).send(data);
        }
    });
});

app.get('/api/stats', function(req, res) {
    dataAccess.stats(function(error, data) {
        if (error) {
            return res.status(500).send(error);
        } else {
            data.webTaskId = process.pid;
            return res.status(200).send(data);
        }
    });
});

http.createServer(app).listen(app.get('port'), function() {
    console.log('Express server listening on port ' + app.get('port'));
});