through = require \through2
duplex  = require \duplexer2
parser  = require \tap-parser
uuid    = require \uuid .v4
stringify-to-yaml = require \js-yaml .dump

module.exports = ->

  tap = parser!
  out = through!

  push-end = !-> out.push null
  push-out = !->
    out
      ..push JSON.stringify it
      ..push \\n

  # Because TAP uses numbers to connect plans and assertions and tapson uses
  # UUIDs, we need to keep a conversion map.
  number-to-id = {}

  last-comment   = null
  plan           = null
  seen-assert    = false

  tap
    ..on \bailout -> push-end!
    ..on \complete -> push-end!
    ..on \comment ->
      last-comment := it.slice 1 # remove leading '#'
                        .trim!   # remove whitespace at ends
    ..on \plan ->
      { start, end } = it
      plan := { start, end }
      for number from start to end
        if not seen-assert
          id = uuid!
          number-to-id[number] = id
          push-out do
            id : id

    ..on \assert ->
      seen-assert := true
      { ok, id : number, name, todo, skip, diag } = it

      maybe = -> if it? then it else ""

      expected = [
        maybe last-comment
        maybe (if last-comment and name then ": ")
        maybe name
      ].reduce (+), ""

      todo = if todo then "TODO: #todo"
      skip = if skip then "SKIP: #skip"
      actual = if diag then stringify-to-yaml that
        else if (todo || skip) then that

      r = {}
        ..ok = ok
        ..expected = expected if expected
        ..id = number-to-id[number] if plan
        ..actual = actual if actual
      push-out r

  return duplex tap, out
