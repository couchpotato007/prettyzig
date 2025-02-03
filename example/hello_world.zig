const std = @import("std");
const prettyzig = @import("prettyzig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try prettyzig.print(stdout, "Hello, World!\n", .{
        .color = .{ .ansi = .brightRed },
        .background = .{ .ansi = .black },
        .styles = &.{ .bold, .underline },
    });
}
