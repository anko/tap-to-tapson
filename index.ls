through = require \through2
duplex  = require \duplexer2
parser  = require \tap-parser

module.exports = ->

  tap = parser!
  out = through!

  push-end = !-> out.push null
  push-out = !->
    out
      ..push JSON.stringify it
      ..push \\n

  last-comment   = null
  plan           = null
  plan-was-first = true

  tap
    ..on \comment ->
      last-comment := it.slice 1 # remove leading '#'
                        .trim!   # remove whitespace at ends
    ..on \assert ->

      if not plan then plan-was-first := false

    ..on \bailout -> push-end!
    ..on \complete -> push-end!
    ..on \plan ->
      plan := {}{ start, end } = it
    ..on \assert ->
      { ok, id, name } = it
      r = {}
        ..ok = ok
        ..description = last-comment if last-comment
        ..expected = name if name
      push-out r

  return duplex tap, out
