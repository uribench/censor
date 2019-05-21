#!/usr/bin/env bash

source helpers/test_censor_exit_code_for_single_file.sh

test_censor_exit_code_for_single_folder() {
  folder=$1
  expected_exit_code=$2
  blacklist=fixtures/test-blacklist.txt

  for file in $folder/*; do
    test_censor_exit_code_for_single_file $blacklist $file $expected_exit_code
  done
}
