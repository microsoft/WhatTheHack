module.exports = {

    writeResponse: function (res, data) {
        data = data.toString();
        res.writeHead(200, { 'Content-Type': 'text/html', 'Content-Length': data.length });
        res.write(data);
        res.end();
    },

    writeError: function (res, data) {
        data = data.toString();
        res.writeHead(500, { 'Content-Type': 'text/html', 'Content-Length': data.length });
        res.write(data);
        res.end();
    }
}