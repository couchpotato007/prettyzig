const std = @import("std");

pub const AnsiColor = enum(u32) {
    reset = 0,
    black = 30,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    brightBlack = 90,
    brightRed,
    brightGreen,
    brightYellow,
    brightBlue,
    brightMagenta,
    brightCyan,
    brightWhite,
};

pub const TextStyle = enum(u32) {
    reset = 0,
    bold = 1,
    dim,
    italic,
    underline,
    blink,
    invert = 7,
    hidden,
    strikethrough,
};

pub const RGB = struct {
    r: u8,
    g: u8,
    b: u8,

    pub fn init(r: u8, g: u8, b: u8) RGB {
        return RGB{ .r = r, .g = g, .b = b };
    }
};

pub const Color = union(enum) {
    ansi: AnsiColor,
    rgb: RGB,
};

pub const PrintOptions = struct {
    color: ?Color = null,
    background: ?Color = null,
    styles: []const TextStyle = &.{},
    debug: bool = false,
};

pub fn print(writer: anytype, text: []const u8, options: PrintOptions) !void {
    if (options.debug) {
        try writer.print("\\x1b[", .{});
    } else {
        try writer.print("\x1b[", .{});
    }

    if (options.color) |fg| {
        switch (fg) {
            .ansi => |c| try writer.print("{d}", .{@intFromEnum(c)}),
            .rgb => |c| try writer.print("38;2;{d};{d};{d}", .{ c.r, c.g, c.b }),
        }
    }

    if (options.background) |bg| {
        switch (bg) {
            .ansi => |c| try writer.print(";{d}", .{@intFromEnum(c) + 10}),
            .rgb => |c| try writer.print("48;2;{d};{d};{d}", .{ c.r, c.g, c.b }),
        }
    }

    for (options.styles) |st| {
        try writer.print(";{d}", .{@intFromEnum(st)});
    }

    try writer.print("m", .{});

    try writer.print("{s}", .{text});

    if (options.debug) {
        try writer.print("\\x1b[0m", .{});
    } else {
        try writer.print("\x1b[0m", .{});
    }
}
