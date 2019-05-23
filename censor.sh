#!/usr/bin/env bash

usage() {
  CMD_NAME="./censor.sh"

  printf "Usage:\n"
  printf "  %s -h|--help|help\n" "$CMD_NAME"
  printf "    Show this message\n\n"
  printf "  %s -v|--version|version\n" "$CMD_NAME"
  printf "    Show version number\n\n"
  printf "  %s BLACKLIST [FILE]...\n" "$CMD_NAME"
  printf "    Example: %s blacklist.txt .\n\n" "$CMD_NAME"
  printf "With no option or no BLACKLIST, assume -h.\n"
  printf "With no FILE, scan '.'.\n"
  printf "Exit status is 9 if any blacklisted word is found, 0 otherwise.\n"
}

use_encrypted_blacklist() {
  tempblacklist=/tmp/blacklist.txt
  gpg2 --batch --passphrase="$BLACKLIST_PASSWORD" -d "$blacklist" > $tempblacklist
  blacklist=$tempblacklist

  trap on_exit EXIT
}

on_exit() {
  rm -f $tempblacklist
}

check_blacklisted_words() {
  if grep -Rinw --color -f $blacklist "${folders[@]}" ; then
    echo "FAIL: There are some blacklisted words in the repository"
    exit 9
  else
    echo "PASS: There are no known blacklisted words in the repository"
    exit 0
  fi
}

run() {
  NO_ARGS=0
  if [ $# -eq "$NO_ARGS" ]; then
    usage
    exit 1
  fi

  case "$1" in
    -h | --help    | help    ) usage; exit 0 ;;
    -v | --version | version ) echo "$VERSION"; exit 0 ;;
  esac

  blacklist=$1
  shift
  folders=("$@")  # parentheses are needed to store the positional parameters in an array.
                  # later it will be used in 'grep' using array expansion syntax

  if [[ $blacklist == *.gpg ]]; then
    use_encrypted_blacklist
  fi

  check_blacklisted_words
}

initialize() {
  VERSION="0.2.2"
  set -eu
}

main() {
  initialize
  run "$@"
}

main "$@"
