const std = @import("std");
const prettyzig = @import("prettyzig");

pub fn main() !void {
    var printer = prettyzig.Printer.init();

    printer.print("Hello, World!\n")
        .color(.brightRed)
        .background(.black)
        .style(.{ .bold, .underline })
        .run();
}
