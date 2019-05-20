#!/usr/bin/env bash

testfile() {
  file=$1
  expected_exit_code=$2

  ../censor.sh fixtures/test-blacklist.txt "$file" > /dev/null
  exitcode=$?
  
  if [[ $exitcode == $expected_exit_code ]]; then
    echo "PASS: $file"
    passed=$(($passed + 1))
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
  passed=0
  failed=0
  plainbalcklistfile=fixtures/test-blacklist.txt

  if [[ ! -f $plainbalcklistfile ]]; then
    gpg2 --batch --passphrase=$PASSWORD -d $plainbalcklistfile.gpg > $plainbalcklistfile
  fi

  testfolder fixtures/pass 0
  testfolder fixtures/fail 9

  if [[ $failed == 0 ]]; then
    echo "ALL PASS (total of $passed tests)"
    exit 0
  else
    total=$(($failed + $passed))
    echo "FAILED: $failed errors (out of $total tests)"
    exit 1
  fi
}

main
