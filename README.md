# tsget

`tsget` is a small Bash utility that converts common time range strings into Unix epoch milliseconds (start/end), with colored terminal output.

## Requirements

- Bash
- GNU `date` (from coreutils), because the script uses `date -d ...`

### macOS note

macOS uses BSD `date` by default, which does not support `-d`. Install GNU coreutils (for example via Homebrew) and use GNU `date` (`gdate`) compatibility approaches if needed.

## Usage

Run directly:

```bash
./ts_get.sh "last hour"
```

Show demo output:

```bash
./ts_get.sh --demo
```

If run without an argument, the script prints a usage message and exits non-zero.

Source and call as a library function:

```bash
source ./ts_get.sh
ts_get "yesterday"
```

## Supported time range strings

- `last 15 minutes`
- `last hour`
- `last 8 hours`
- `last 24 hours`
- `last 3 days`
- `last 30 days`
- `last month`
- `last year`
- `today`
- `yesterday`
- `this week`
- `last week`
- `last Mon`
- `last Tue`
- `last Wed`
- `last Thu`
- `last Fri`
- `last Sat`
- `last Sun`
- `last Mon-Wed`
- `last week day` (alias of `last Mon-Fri`)
- `last Mon-Fri`

## Example output

```text
Time Range: "last hour"
  Start:    1715336400000
  End:      1715340000000
```
