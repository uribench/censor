#!/usr/bin/env bash
set -u            # '-e' option is not used since 'grep' returns 1 when nothing is found

blacklist=$1
shift
folders=("$@")    # parentheses are needed to store the positional parameters in an array.
                  # later it will be used in 'grep' using array expansion syntax

if [[ -z ${folders[*]} ]]; then
  echo "Usage: $0 BLACKLIST [FILE]..."
  echo "Example: $0 blacklist.txt ."
  exit 1
fi

if [[ $blacklist == *.gpg ]]; then
  tempblacklist=/tmp/blacklist.txt
  gpg2 --batch --passphrase="$BLACKLIST_PASSWORD" -d "$blacklist" > $tempblacklist
  blacklist=$tempblacklist
  trap 'rm -f $tempblacklist' EXIT
fi

grep -Rinw --color -f $blacklist "${folders[@]}" 

if [[ $? == 0 ]]; then
  echo "FAIL: There are some blacklisted words in the repository"
  exit 9
else
  echo "PASS: There are no known blacklisted words in the repository"
  exit 0
fi
