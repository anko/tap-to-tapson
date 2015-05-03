transformer = require \./index.ls

process.stdin .pipe transformer! .pipe process.stdout
