exports.appSettings = {
    db: (function() {
        return process.env.MONGODB_CONNECTION || 'mongodb://localhost:27017/contentdb';
    })()
};