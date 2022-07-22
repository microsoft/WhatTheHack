'use strict';
var http = require('http');
var jsdom = require('jsdom');
var { JSDOM } = jsdom;
var fs = require('fs');
var port = process.env.PORT || 8092;
var dbOperations = require('./databaseOperations.js');
var utils = require('./utils.js');
var config = JSON.parse(fs.readFileSync('config.json', 'utf8'));


var lastTimestamp = 0;
var server = http.createServer(function (req, res) {
    var reqUrl = req.url.replace(/^\/+|\/+$/g, '');
    var method = req.method.toLowerCase();
    
    if(config.enableSecretsFeature) {
        console.log(req.headers['x-secret']);
        console.log(process.env.HEADER_VALUE);
        if(req.headers['x-secret'] != process.env.HEADER_VALUE) {
            res.writeHead(401, "Unauthorized");
            res.end();
            return;
        }
    }
    if(!reqUrl || (!!reqUrl && (reqUrl == "" || reqUrl.toLowerCase() == "index.html"))){
        var data = fs.readFileSync('index.html');
        
        dbOperations.queryCount(function (visitCount){
            visitCount++;
            var dom = new JSDOM(`${data}`);
            var visitCountElement = dom.window.document.getElementById("visitCount");
            if(!!visitCountElement){
                visitCountElement.innerHTML = "Total visits: " + visitCount;
            }
            var lastVisitElement = dom.window.document.getElementById("lastTimestamp");
            if(!!lastVisitElement) {
                lastVisitElement.innerHTML = "Time since last visit (in milliseconds): " + (lastTimestamp == 0 ? "Never visited" : (Date.now() - lastTimestamp));
            }
            lastTimestamp = Date.now();
            data = dom.serialize();
            utils.writeResponse(res, data);
            dbOperations.addRecord("index", function(){
            }, function(error){
                // utils.writeResponse(res, data);
            });
        }, function(error){ 
            utils.writeError(res, error);
        });
    }
    else if(!!reqUrl && reqUrl.toLowerCase() == "get" && method == "get") {
        setTimeout(() => {
            dbOperations.queryCount(function (visitCount){
                // total = visitCount + 1;
                utils.writeResponse(res, visitCount + 1);
            }, function(error){
                utils.writeError(res, error);
            });
        }, 10);
    }
    else if(!!reqUrl && reqUrl.toLowerCase() == "add" && method == "post") {
        setTimeout(() => {
            let body = "";
            let entries = 0;
            req.on('data', chunk => {
                body += chunk;
            })
            req.on('end', () => {
                console.log("add request body: " + body)
                entries = parseInt(body) // 'Buy the milk'
                var counter = 0;
                var success = 0;
                console.log(entries)
                if(entries == 0) {
                    utils.writeResponse(res, "added " + entries + " entries")
                }
                for(let i = 0; i < entries; i++) {
                    dbOperations.addRecord("index", function(){
                        lastTimestamp = Date.now();
                        counter++; success++;
                        if(counter == entries) {
                            utils.writeResponse(res, "added " + success + " entries")
                        }
                    }, function(error){
                        counter++;
                        if(counter == entries) {
                            utils.writeResponse(res, "added " + success + " entries")
                        }
                    });
                }
            }) 
        }, 10);
    }
    else if(reqUrl.toLowerCase() == "lasttimestamp" && method == "get"){
        setTimeout(() => {
            utils.writeResponse(res, lastTimestamp);
        }, 10);
    }
    else {
        utils.writeResponse(res, "not found");
    }
});

exports.listen = function () {
    server.listen.apply(server, arguments);
};
  
exports.close = function (callback) {
    server.close(callback);
};

server.listen(port);
