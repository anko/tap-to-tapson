transformer = require \./index.js

process.stdin .pipe transformer! .pipe process.stdout
