//  Simple json response 
//      message: informational
//      status: http status code
//      payload: json data payload

module.exports = function (msg, status, payload) {
    
    this.message = msg;
    this.status = status;
    this.payload = payload;

    return this;
}