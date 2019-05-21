#!/usr/bin/env bash

source helpers/test_censor_exit_code_for_single_folder.sh

main() {
  passed=0
  failed=0

  test_censor_exit_code_for_single_folder fixtures/pass 0
  test_censor_exit_code_for_single_folder fixtures/fail 9

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
