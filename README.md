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

Create release tar:

```
tar -czvf remext-<verion>.tar.gz -C _build/release/rel/bakeware .
```

## Install

Download the latest version:

```
curl https://gitea.flightless.dev/api/packages/erik/generic/remext/<version>/remext.tar.gz -o remext.tar.gz
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

### Troubleshooting

The install method is still very untested. Here is listed some known issues and sometimes solutions:

1. Problem:

   ```
   bakeware: Error creating directory /some/path/.cache/bakeware/.tmp/rUGLhC??: No such file or directory
   bakeware: Unrecoverable validation error
   ```

   Solution:

   Manually create the directory `/some/path/.cache/bakeware/.tmp/`

2. Problem:
   ```
   /lib/x86_64-linux-gnu/libc.so.6: version 'GLIBC_2.34' not found
   ```
   Solution:
   1. Install libc6 version 2.34 or newer
   2. If it isn't available you have to compile locally. Requires elixir and mix
   3. Help me generalize the building process to multiple distributions
