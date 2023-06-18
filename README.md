# Remext

A simple cli for manage and access a key map with information you want to remember, i.e. commands, links etc.

## Usage

The default usage is

```
remext key
```

to read a value you stored at `key`.

You set a new value at `key` with

```
remext key --set/-s value
```

or

```
remext key --set/-s value --delete/-d
```

to override anything already stored at `key`.

You can also delete an entry with

```
remext key --delete/-d
```

and search through all keys with

```
remext phrase --search/-q
```

If phrase is empty a list of all keys will be given.

## Build

To build the binary run

```
MIX_ENV=release mix release remext
```

It will then be placed in `_build/release/rel/bakeware/remext`
