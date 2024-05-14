var MongoClient = require('mongodb').MongoClient;
var fs = require('fs');

var obj = JSON.parse(fs.readFileSync('connectionData.json', 'utf8'));
var DbConnection = function () {

    var db = null;
    var instance = 0;

    async function DbConnect() {
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
        
        try {
            let _db = await MongoClient.connect(connectionString);

            return _db.db(databaseName).collection(collectionName);
        } catch (e) {
            console.log("Error connecting to db")
            console.log(connectionString)
            console.log(databaseName)
            console.log(collectionName)
            console.log(e)
            return e;
        }
    }

   async function Get() {
        try {
            instance++;     // this is just to count how many times our singleton is called.
            console.log(`DbConnection called ${instance} times`);

            if (db != null) {
                console.log(`db connection is already alive`);
                // db = await DbConnect(); // Bug, remove this line to enable connection pooling
                return db;
            } else {
                console.log(`getting new db connection`);
                db = await DbConnect();
                return db; 
            }
        } catch (e) {
            return e;
        }
    }

    return {
        Get: Get
    }
}


module.exports = DbConnection();