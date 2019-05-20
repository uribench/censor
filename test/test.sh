#!/usr/bin/env bash

testfile() {
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

testfolder() {
  folder=$1
  expected_exit_code=$2

  for file in $folder/*; do
    testfile $file $expected_exit_code
  done
}

main() {
  failed=0

  testfolder fixtures/pass 0
  testfolder fixtures/fail 9

  if [[ $failed == 0 ]]; then
    echo "ALL PASS"
    exit 0
  else
    echo "FAILED: $failed errors"
    exit 1
  fi
}

main
