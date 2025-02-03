const std = @import("std");
const prettyzig = @import("prettyzig");
const RGB = prettyzig.RGB;

pub const CatppuccinMocha = struct {
    pub const rosewater = RGB.init(255, 239, 217); // #fdf0db
    pub const flamingo = RGB.init(248, 204, 255); // #f8ccff
    pub const pink = RGB.init(255, 183, 227); // #ffb7e3
    pub const mauve = RGB.init(189, 147, 249); // #bd93f9
    pub const red = RGB.init(255, 85, 85); // #ff5555
    pub const orange = RGB.init(255, 184, 108); // #ffb86c
    pub const yellow = RGB.init(241, 250, 140); // #f1fa8c
    pub const green = RGB.init(139, 233, 255); // #8ef6ff
    pub const teal = RGB.init(80, 253, 247); // #50fdf7
    pub const sky = RGB.init(96, 189, 255); // #60bdff
    pub const sapphire = RGB.init(94, 115, 255); // #5e73ff
    pub const blue = RGB.init(139, 227, 255); // #8be3ff
    pub const lavender = RGB.init(159, 183, 255); // #9fb7ff
    pub const text = RGB.init(248, 248, 242); // #f8f8f2
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try prettyzig.print(stdout, "Normal text\n", .{});

    try prettyzig.print(stdout, "Rosewater\n", .{ .color = .{ .rgb = CatppuccinMocha.rosewater }, .styles = &.{.bold} });

    try prettyzig.print(stdout, "Flamingo\n", .{ .color = .{ .rgb = CatppuccinMocha.flamingo }, .styles = &.{.italic} });

    try prettyzig.print(stdout, "Mauve\n", .{ .color = .{ .rgb = CatppuccinMocha.mauve }, .styles = &.{ .bold, .underline } });

    try prettyzig.print(stdout, "Green\n", .{ .color = .{ .rgb = CatppuccinMocha.green }, .styles = &.{ .bold, .italic } });

    try prettyzig.print(stdout, "Orange\n", .{ .color = .{ .rgb = CatppuccinMocha.orange }, .styles = &.{ .italic, .strikethrough } });
}
