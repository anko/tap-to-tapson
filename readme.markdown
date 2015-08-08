# tap-to-tapson

    <tap-producer> | tap-to-tapson | <tapson-consumer>

Reads [TAP 13][1].

Comments are interpreted as the description of the following tests, until the
next comment appears.  Markers for "TODO", "skip" and "diag" are added to the
description field too.

## Examples

<!-- !test program lsc cli.ls | head -c -1 -->

The description is put everywhere because tapson streams don't support comments
or any other state that would let one line of description affect how the others
are interpreted.

<!-- !test in simple example -->

    TAP version 13
    # Serious business
    ok 1 should throw
    ok 2
    ok 3
    1..3

<!-- !test out simple example -->

    {"ok":true,"description":"Serious business","expected":"should throw"}
    {"ok":true,"description":"Serious business"}
    {"ok":true,"description":"Serious business"}

* * *

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
