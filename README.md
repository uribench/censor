# Search for Blacklisted Words

## Blacklisting

The file with the blacklisted words is encrypted. Only the encrypted version of the blacklist file exists on the public repository. However, all the included automation scripts (i.e., locally and on CI machines) are using the plain text version of the blacklist file. Therefore, if the plain text version doesn't exist when the scripts are executed, they decrypt it from the provided encrypted file using:

```bash
$ gpg2 --batch --passphrase=$PASSWORD -d blacklist.txt.gpg > blacklist.txt
```

To update the blacklist file follow these steps:

1. **Update:** Put all the blacklisted words in a file (e.g., `blacklist.txt`). Each word has to be placed in a separate line, as `grep` takes the whole line for pattern match.

2. **Encrypt:** Assuming the blacklist file is `blacklist.txt` and the right encryption passphrase is in `PASSWORD` environment variable (e.g., via `.envrc` file), encrypt it using the following command:

```bash
$ gpg2 --batch --passphrase=$PASSWORD -c blacklist.txt
```

## Execution

Run the `censor.sh` script as follows:

```bash
$ ./censor.sh BLACKLIST [FILE]...

# Example:
$ ./censor.sh blacklist.txt ../Guides/ ../Topics/ ../config/
```

Note:

There is no need to include the `Handbook` folder as a target for the search, as it is generated automatically from the contents in the `config` folder and includes only `index.md` files with references to the contents in the `Guides` and `Topics` folders.

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
