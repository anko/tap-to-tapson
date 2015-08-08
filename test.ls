#!/usr/bin/env lsc

test          = require \tape
tap-to-tapson = require \./index.ls
through       = require \through2
concat        = require \concat-stream

# Create a dummy stream for given output
test-stream = (output) ->
  through!
    ..push output
    ..push null

test "plain ok tests" (t) ->
  t.plan 1

  s = test-stream do
    '''
    TAP version 13
    ok 1
    ok 2
    1..2
    '''
  s.pipe tap-to-tapson! .pipe concat (output) ->
    t.equals do
      output.to-string!
      '''
      {"ok":true}
      {"ok":true}

      '''
    t.end!

test "comments become descriptions" (t) ->
  t.plan 1

  s = test-stream do
    '''
    TAP version 13
    # test number one
    ok 1
    # test number two
    ok 2
    1..2
    '''
  s.pipe tap-to-tapson! .pipe concat (output) ->
    t.equals do
      output.to-string!
      '''
      {"ok":true,"description":"test number one"}
      {"ok":true,"description":"test number two"}

      '''
    t.end!

test "initially planned tests" (t) ->
  s = test-stream do
    '''
    TAP version 13
    1..2
    ok 1
    ok 2
    '''
  s.pipe tap-to-tapson! .pipe concat (output) ->

    # Have to track some state because TAP uses numbers and tapson uses UUIDs
    # to connect plans and corresponding tests.
    numbers-to-ids = {}

    output = output.to-string!trim!

    output.split "\n"
      ..slice 0,2
        ..length `t.equals` 2
        ..for-each (d, i) ->
          d = JSON.parse d
          numbers-to-ids[i] = d.id
          t.not-ok d.ok, "Initial two are not results"
      ..slice 2
        ..length `t.equals` 2
        ..for-each (d, i) ->
          d = JSON.parse d
          t.equals numbers-to-ids[i], d.id
          t.ok d.ok, "Last two are results"
    t.end!
