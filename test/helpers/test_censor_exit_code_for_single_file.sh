#!/usr/bin/env bash

test_censor_exit_code_for_single_file() {
  blacklist=$1
  target_file=$2
  expected_exit_code=$3

  ../censor.sh "$blacklist" "$target_file" > /dev/null
  exitcode=$?
  
  if [[ $exitcode == $expected_exit_code ]]; then
    echo "PASS: $file"
    passed=$(($passed + 1))
  else
    echo "FAIL: $file exited with $exitcode"
    failed=$(($failed + 1))
  fi
}
