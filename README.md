[![Build Status](https://travis-ci.com/uribench/censor.svg?branch=master)](https://travis-ci.org/uribench/censor)

# Search for Blacklisted Words

The `censor.sh` script searches for blacklisted words in target files. It uses an external file containing blacklisted words.

## Usage

```bash
$ ./censor.sh BLACKLIST [FILE]...

# Examples: 
$ ./censor.sh blacklist.txt .
$ ./censor.sh blacklist.txt.gpg .
```

The `BLACKLIST` parameter of `censor.sh` script can be provided as a plain text file or as an encrypted file. When an encrypted blacklist file is used, it has to be created with `gpg2` using a symmetric cipher. The encryption/decryption passphrase is expected to be in `BLACKLIST_PASSWORD` environment variable.

## Maintaining the Blacklist File

Changes to the blacklist file are done on its plain text version. The `censor.sh` script is making use of the `grep` command, therefore, each blacklisted word has to be placed in a separate line (i.e., `grep` takes the whole line for pattern match). 

Following are the two commands to encrypt/decrypt the blacklist file when needed. These commands are using `blacklist.txt` as an example:

```bash
# Encrypt:
$ gpg2 --batch --passphrase=$BLACKLIST_PASSWORD -c blacklist.txt

# Decrypt: 
$ gpg2 --batch --passphrase=$BLACKLIST_PASSWORD -d blacklist.txt.gpg > blacklist.txt
```

Note: If you decide to use the encrypted blacklist and would like to avoid uploading its plain text version to a public repository, then remember to add its name to the `.gitignore` file. For example, the line `*blacklist.txt` ignores all plain text blacklists with filenames ending with "\*blacklist.txt", such as "test-balcklist.txt.

## Testing

The `censor.sh` script is tested using multiple 'pass/fail' fixtures placed in their respective folders under `./test/`.

Run all tests using:

```bash
$ cd test
$ ./test.sh

# Example output:
PASS: fixtures/pass/pass-prefixed.md
PASS: fixtures/pass/pass-suffixed.md
PASS: fixtures/fail/fail-all_lower_case.md
PASS: fixtures/fail/fail-all_upper_case.md
PASS: fixtures/fail/fail-email_address.md
PASS: fixtures/fail/fail-mixed_case.md
ALL PASS (total of 6 tests)
```
