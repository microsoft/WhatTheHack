const express = require('express');
const http = require('http');
const path = require('path');
const request = require('request');

const app = express();

app.use(express.static(path.join(__dirname, 'dist/content-web')));
const contentApiUrl = process.env.CONTENT_API_URL || "http://localhost:3001";


function getSessions(cb) {
  request(contentApiUrl + '/sessions', function (err, response, body) {
    if (err) {
      return cb(err);
    }
    const data = JSON.parse(body); // Note: ASSUME: valid JSON
    cb(null, data);
  });
}

function getSpeakers(cb) {
  request(contentApiUrl + '/speakers', function (err, response, body) {
    if (err) {
      return cb(err);
    }
    const data = JSON.parse(body); // Note: ASSUME: valid JSON
    cb(null, data);
  });
}

function stats(cb) {
  request(contentApiUrl + '/stats', function (err, response, body) {
    if (err) {
      return cb(err);
    }
    const data = JSON.parse(body);
    cb(null, data);
  });
}

app.get('/api/speakers', function (req, res) {
  getSpeakers(function (err, result) {
    if (!err) {
      res.send(result);
    } else {
      res.send(err);
    }
  });
});
app.get('/api/sessions', function (req, res) {
  getSessions(function (err, result) {
    if (!err) {
      res.send(result);
    } else {
      res.send(err);
    }
  });
});
app.get('/api/stats', function (req, res) {
  stats(function (err, result) {
    if (!err) {
      result.webTaskId = process.pid;
      res.send(result);
    } else {
      res.send(err);
    }
  });
});



app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist/content-web/index.html'));
});
const port = process.env.PORT || '3000';
app.set('port', port);

const server = http.createServer(app);
server.listen(port, () => console.log('Running'));
