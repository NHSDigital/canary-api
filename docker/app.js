const express = require('express');

const app = express();

app.get('/', (req, res) => { res.send("Tweet, tweet.") });
app.get('/_health', (req, res) => { res.send("OK") });

module.exports = app;
