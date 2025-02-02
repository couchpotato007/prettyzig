const std = @import("std");

pub const Color = enum(u32) {
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

pub const Printer = struct {
    text: []const u8,
    fground: ?Color = null,
    bground: ?Color = null,
    styles: []const TextStyle = &[_]TextStyle{},
    custom_fg: ?RGB = null,
    custom_bg: ?RGB = null,
    debug: bool = false,

    pub fn init() Printer {
        return Printer{ .text = "", .fground = null, .bground = null, .styles = &[_]TextStyle{}, .custom_fg = null, .custom_bg = null, .debug = false };
    }

    pub fn color(self: *Printer, fgcolor: Color) *Printer {
        self.fground = fgcolor;
        return self;
    }

    pub fn background(self: *Printer, bgcolor: Color) *Printer {
        self.bground = bgcolor;
        return self;
    }

    pub fn style(self: *Printer, styles: anytype) *Printer {
        self.styles = &styles;
        return self;
    }

    pub fn color_rgb(self: *Printer, rgb: RGB) *Printer {
        self.custom_fg = rgb;
        return self;
    }

    pub fn background_rgb(self: *Printer, rgb: RGB) *Printer {
        self.custom_bg = rgb;
        return self;
    }

    pub fn enable_debug(self: *Printer) *Printer {
        self.debug = true;
        return self;
    }

    pub fn print(self: *Printer, text: []const u8) *Printer {
        self.text = text;
        return self;
    }

    pub fn run(self: *Printer) void {
        const stdout = std.io.getStdOut().writer();

        if (self.debug) {
            stdout.print("\\x1b[", .{}) catch {
                handle_write_error("debug start sequence");
            };
        } else {
            stdout.print("\x1b[", .{}) catch {
                handle_write_error("start sequence");
            };
        }

        if (self.custom_fg) |fg| {
            stdout.print("38;2;{d};{d};{d}", .{ fg.r, fg.g, fg.b }) catch {
                handle_write_error("custom color");
            };
        } else if (self.fground) |fg| {
            stdout.print("{d}", .{@intFromEnum(fg)}) catch {
                handle_write_error("color");
            };
        }

        if (self.custom_bg) |bg| {
            stdout.print(";48;2;{d};{d};{d}", .{ bg.r, bg.g, bg.b }) catch {
                handle_write_error("custom background");
            };
        } else if (self.bground) |bg| {
            stdout.print(";{d}", .{@intFromEnum(bg) + 10}) catch {
                handle_write_error("background");
            };
        }

        for (self.styles) |st| {
            stdout.print(";{d}", .{@intFromEnum(st)}) catch {
                handle_write_error("styles");
            };
        }

        stdout.print("m", .{}) catch {
            handle_write_error("end");
        };

        stdout.print("{s}", .{self.text}) catch {
            handle_write_error("text");
        };

        if (self.debug) {
            stdout.print("\\x1b[0m", .{}) catch {
                handle_write_error("debug end sequence");
            };
        } else {
            stdout.print("\x1b[0m", .{}) catch {
                handle_write_error("end sequence");
            };
        }

        self.fground = null;
        self.bground = null;
        self.styles = &[_]TextStyle{};
        self.custom_fg = null;
        self.custom_bg = null;
        self.debug = false;
    }
};

fn handle_write_error(msg: []const u8) void {
    std.log.err("Pretty Printer: Error writer: {s}", .{msg});
}
