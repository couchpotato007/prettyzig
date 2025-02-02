const std = @import("std");
const pretty = @import("pretty");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .stack_trace_frames = 50 }){};
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) {
            std.log.err("memory leak", .{});
        }
    }

    // const allocator = gpa.allocator();

    var printer = pretty.Printer.init();

    printer.print("Hello, World!\n")
        .color(.brightRed)
        .background(.black)
        .style(.{ .bold, .underline })
    // .enable_debug()
        .run();
}
