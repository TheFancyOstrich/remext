# Remext

A simple cli for managing a key map with information you want to remember, i.e. commands, links etc. Passwords are not recommended since the key value pairs are stored as plain text.

Example usage:

```
> remext link-to-that-random-tool-I-found --set https://gitea.flightless.dev/erik/remext
...
> remext link-to-that-random-tool-I-found
> https://gitea.flightless.dev/erik/remext
```

## Usage

The default usage is

```
> remext key
```

to read a value you stored at `key`.

You set a new value at `key` with

```
> remext key --set/-s value
```

or

```
> remext key --set/-s value --delete/-d
```

to override anything already stored at `key`. Note that to include spaces in either the value or key it has to be wrapped in quotes, and if quotes are to be included in the value they have to be escaped using \", e.g.:

```
> remext key --set "Long value with spaces and \"quotes\""
```

You can also delete an entry with

```
> remext key --delete/-d
```

You can also search the keys using

```
> remext phrase --search_keys/-q
```

or all values with

```
> remext phrase --search_values/-w
```

or both

```
> remext phrase -qw
```

If phrase is empty a list of all keys will be given.

## Build

To build the binary run

```
cargo build --release --features home_path
```

the feature sets the binary to use `~/.config/remext.json` instead of `./test.json`.
It will then be placed in `target/release/remext`

## Install

Download the latest version:

```
curl https://gitea.flightless.dev/api/packages/flightless/generic/remext/<version>/remext.tar.gz -o remext.tar.gz
```

Extract:

```
tar -xzvf remext.tar.gz
```

Move to path

```
(sudo) mv remext /suitable/path/to
```

Example path `/usr/local/bin`
