#!/usr/bin/env node

var static = require('node-static');

var fileServer = new static.Server('.');

require('http').createServer(function (request, response) {
    request.addListener('end', function () {
        fileServer.serve(request, response);
    }).resume();
}).listen(3000);

console.log('Server listening on localhost:3000');