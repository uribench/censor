# Search for Blacklisted Words

## Blacklisting

Put all the blacklisted words in a file (e.g., `blacklist.tx`). Each word has to be placed in a separate line, as `grep` takes the whole line for pattern match.

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
