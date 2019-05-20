#!/usr/bin/env bash

runtest() {
  file=$1
  expected_exit_code=$2

  ../censor.sh fixtures/test-blacklist.txt "$file" > /dev/null
  exitcode=$?
  
  if [[ $exitcode == $expected_exit_code ]]; then
    echo "PASS: $file"
  else
    echo "FAIL: $file exited with $exitcode"
    failed=$(($failed + 1))
  fi
}

main() {
  failed=0

  for file in fixtures/pass/*; do
    runtest $file 0
  done

  for file in fixtures/fail/*; do
    runtest $file 9
  done

  if [[ $failed == 0 ]]; then
    echo "ALL PASS"
    exit 0
  else
    echo "FAILED: $failed errors"
    exit 1
  fi
}

main
