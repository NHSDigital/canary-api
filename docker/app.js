const express = require('express');

const app = express();

function ping_handler(req, res) {
    let version_info =  JSON.parse(process.env.VERSION_INFO || '{}');
    res.json({
        ping: "pong",
        service: "canary",
        _version: version_info
    });
}

app.get('/', (req, res) => { res.send("Hello user!") });
app.get('/_health', (req, res) => { ping_handler(req, res) });
app.get('/_status', (req, res) => { ping_handler(req, res) });
app.get('/_ping', (req, res) => { ping_handler(req, res) });

module.exports = app;
