[![Build Status](https://travis-ci.com/uribench/censor.svg?branch=master)](https://travis-ci.com/uribench/censor)

# Search for Blacklisted Words

The `censor.sh` script searches for blacklisted words in target files. It uses an external file containing blacklisted words.

## Usage

```bash
$ ./censor.sh BLACKLIST [FILE]...

# Examples: 
$ ./censor.sh blacklist.txt .
$ ./censor.sh blacklist.txt.gpg .
```

The `BLACKLIST` parameter of `censor.sh` script can be provided as a plain text file or as an encrypted file. When an encrypted blacklist file is used, it has to be created with `gpg2` using a symmetric cipher. The encryption/decryption passphrase is expected to be in `BLACKLIST_PASSWORD` environment variable. For additional details on the encrypted blacklist file and encryption/decryption passphrase see [this][1] section below.

To learn about more usage options see the online help:

```bash
$ ./censor.sh -h
```

## Maintaining the Blacklist File

Changes to the blacklist file are done on its plain text version. The `censor.sh` script is making use of the `grep` command, therefore, each blacklisted word has to be placed in a separate line (i.e., `grep` takes the whole line for pattern match). 

Following are the two commands to encrypt/decrypt the blacklist file when needed. These commands are using `blacklist.txt` as an example:

```bash
# Encrypt:
$ gpg2 --batch --passphrase=$BLACKLIST_PASSWORD -c blacklist.txt

# Decrypt: 
$ gpg2 --batch --passphrase=$BLACKLIST_PASSWORD -d blacklist.txt.gpg > blacklist.txt
```

### Notes on Encrypted Blacklist File and Encryption/Decryption Passphrase

If you decide to use the encrypted blacklist and would like to avoid uploading its plain text version to a public repository, then remember to add its name to the local `.gitignore` file. For example, the line `*blacklist.txt` ignores all plain text blacklists with filenames ending with "\*blacklist.txt", such as "test-balcklist.txt.

When the local encryption/decryption passphrase in `BLACKLIST_PASSWORD` environment variable is defined in a local configuration file, then remember to add it to the git ignore list. For instance, when using an environment switcher for the shell, such as [direnv][2], then the passphrase will typically be defined in the local `.envrc` and ignored globally in `~/.gitignore_global`.

Typically, CI servers provide a way to define environment variables. This is used here to store secretly the encryption/decryption passphrase on Travis-CI.

## Static Analysis

Static Analysis is done using [ShellCheck][3]. It is done locally and is also part of the CI (performed by Travis-CI that already it pre-installed).

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

---

[1]: #notes-on-encrypted-blacklist-file-and-encryptiondecryption-passphrase
[2]: https://direnv.net/
[3]: https://github.com/koalaman/shellcheck