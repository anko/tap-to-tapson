# tap-to-tapson

Reads [TAP 13][1], produces tapson as equivalently as possible.

    <tap-producer> | tap-to-tapson | <tapson-consumer>

Also works as a node module, with streams:

    var tapToTapson = require("tap-to-tapson")();
    process.stdin.pipe(tapToTapson).pipe(process.stdout);

## Mapping examples

<!-- !test program ./cli.js | head -c -1 -->

Comments are interpreted as a "heading" for the `expected` properties of the
following tests, until the next comment appears.

<!-- !test in simple example -->

    TAP version 13
    ok 1 before any headings
    # Serious business
    ok 2 should throw
    ok 3
    ok 4
    # Even more serious
    ok 5
    ok 6 what
    1..6

<!-- !test out simple example -->

    {"ok":true,"expected":"before any headings"}
    {"ok":true,"expected":"Serious business: should throw"}
    {"ok":true,"expected":"Serious business"}
    {"ok":true,"expected":"Serious business"}
    {"ok":true,"expected":"Even more serious"}
    {"ok":true,"expected":"Even more serious: what"}

Tests marked "TODO" or "SKIP" fail with `actual`-property set to reason given.

<!-- !test in todo-skip -->

    TAP version 13
    not ok 1 answer to life the universe and everything # TODO not written yet
    not ok 2 database smoketest # SKIP database not configured
    1..2

<!-- !test out todo-skip -->

    {"ok":false,"expected":"answer to life the universe and everything","actual":"TODO: not written yet"}
    {"ok":false,"expected":"database smoketest","actual":"SKIP: database not configured"}

Any assert's YAML block goes in the `actual` property. ("TODO" and
"SKIP"-directives are ignored here.)

<!-- !test in yaml-block -->

    TAP Version 13
    not ok 1 Resolve address
      ---
      message: "Failed with error 'hostname peebles.example.com not found'"
      severity: fail
      data:
        got:
          hostname: 'peebles.example.com'
          address: ~
        expected:
          hostname: 'peebles.example.com'
          address: '85.193.201.85'
      ...
    1..1

<!-- !test out yaml-block -->

    {"ok":false,"expected":"Resolve address","actual":"message: \"Failed with error 'hostname peebles.example.com not found'\"\nseverity: fail\ndata:\n  got:\n    hostname: peebles.example.com\n    address: null\n  expected:\n    hostname: peebles.example.com\n    address: 85.193.201.85\n"}

A TAP plan given ahead of time becomes a set of tapson planned tests.  (The
output is representative.  The `id`s are random but match the test results.)

<!-- Egh, don't know how to write a concise shell script to test that, I'll
leave it to the proper unit tests. -->

    TAP version 13
    1..3
    ok 1
    ok 2
    ok 3

<!-- comment just to split the code blocks... -->

    {"id":"2654782ca1d79720181551c031c7ed3f3e157634"}
    {"id":"314cf30f5c39abb4798bbbf30327be092bd765bc"}
    {"id":"a010bf964ecb2709bd1c996630c65b28dff1e99d"}
    {"id":"2654782ca1d79720181551c031c7ed3f3e157634","ok":true}
    {"id":"314cf30f5c39abb4798bbbf30327be092bd765bc","ok":true}
    {"id":"a010bf964ecb2709bd1c996630c65b28dff1e99d","ok":true}

[1]: https://testanything.org/tap-version-13-specification.html
