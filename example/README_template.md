# prettyzig

A simple and easy to use library for colored output. Written with zig 0.14

# Installation

```sh
# Version of prettyzig that works with zig 0.14
zig fetch --save git+https://github.com/couchpotato007/prettyzig
```

Then add the following to `build.zig`:

```zig
const clap = b.dependency("prettyzig", .{{}});
exe.root_module.addImport("prettyzig", clap.module("prettyzig"));
```

# Examples

## Hello World

```zig
{s}
```

## Color pallete

```zig
{s}
```
