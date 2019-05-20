#!/usr/bin/env bash
set -eu

blacklist=$1
shift
folders="$@"

if [[ -z $folders ]]; then
  echo "Usage: $0 BLACKLIST [FOLDERS...]"
  exit 1
fi

for folder in $folders; do
  grep -Rinw --color -f $blacklist $folder

  if [[ $? == 0 ]]; then
    echo "FAIL: There are some blacklisted words in the repository"
    exit 9
  else
    echo "PASS: There are no known blacklisted words in the repository"
    exit 0
  fi
done
