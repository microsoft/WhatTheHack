var MongoClient = require("mongodb").MongoClient;
var fs = require('fs');
var obj = JSON.parse(fs.readFileSync('connectionData.json', 'utf8'));
var DbConnection = require('./db');

var connectionString = "mongodb://account:key@account.documents.azure.com:10255/?ssl=true";
var connectionString = process.env.CONNECTION_STRING; 
var stringSplit1 = connectionString.split("://")[1];
var stringSplit2 = stringSplit1.split('@');
var userNamePassword = stringSplit2[0];
userNamePassword = userNamePassword.split(':');
var userName = userNamePassword[0];
var password = userNamePassword[1];
var databaseName = obj.databaseName;
var collectionName = obj.collectionName;
connectionString = ("mongodb://" + encodeURIComponent(userName) + ":" + encodeURIComponent(password) + "@" + stringSplit2[1] + (stringSplit2.length >= 3 ? ("@" + stringSplit2[2] + "@") : ""));


module.exports = {
    queryCount: function (callback, errorCallback, retry = 2) { 
        DbConnection.Get()
        .then((mongoClient) => {
            // Find some documents
            mongoClient.count(function (err, count) {
                if (err != null) {
                    if(retry > 0) {
                        setTimeout(() => {
                            queryCount(callback, errorCallback, retry-1);
                        }, (3 - retry) * 600);
                        return;
                    } else {
                        errorCallback(err)
                    } 
                } else {
                    console.log(`Found ${count} records`);
                    callback(count);
                }
            });
        })
    },

    addRecord: function (pageName, callback, errorCallback, retry = 2) {
        
        DbConnection.Get()
        .then((mongoClient) => {
            var milliseconds = (new Date).getTime().toString();
            var itemBody = {
                "id": milliseconds,
                "page": pageName
            };
            console.log("Connected correctly to server");
            // Insert some documents
            mongoClient.insertMany([itemBody], function (err, result) {
                if (err != null) {
                    if(retry > 0) {
                        setTimeout(() => {
                            addRecord(pageName, callback, errorCallback, retry-1);
                        }, (3 - retry) * 600);
                        return;
                    } else {
                        errorCallback(err)
                    }
                } else {
                    callback();
                }
            });
        })
    }
}