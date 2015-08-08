# tap-to-tapson

    <tap-producer> | tap-to-tapson | <tapson-consumer>

Reads [TAP 13][1].

Comments are interpreted as a "heading" for the expected value of the following
tests, until the next comment appears.  Markers for "TODO", "skip" and "diag"
are added to the description field too.

## Examples

<!-- !test program lsc cli.ls | head -c -1 -->

Here's how comments work as "headings" for the `expected` property of tests;

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
