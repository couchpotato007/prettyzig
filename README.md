# prettyzig

A simple and easy to use library for colored output. Written with zig 0.13

# Examples

## Hello World

```zig
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

```

## Color pallete

```zig
const std = @import("std");
const pretty = @import("pretty");
const RGB = pretty.RGB;

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
    var gpa = std.heap.GeneralPurposeAllocator(.{ .stack_trace_frames = 50 }){};
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) {
            std.log.err("memory leak", .{});
        }
    }

    // const allocator = gpa.allocator();

    var printer = pretty.Printer.init();

    printer.print("Normal text\n")
        .run();

    printer.print("Rosewater\n")
        .color_rgb(CatppuccinMocha.rosewater)
        .style(.{.bold})
        .run();

    printer.print("Flamingo\n")
        .color_rgb(CatppuccinMocha.flamingo)
        .style(.{.italic})
        .run();

    printer.print("Mauve\n")
        .color_rgb(CatppuccinMocha.mauve)
        .style(.{ .bold, .underline })
        .run();

    printer.print("Green\n")
        .color_rgb(CatppuccinMocha.green)
        .style(.{ .bold, .italic })
        .run();

    printer.print("Orange\n")
        .color_rgb(CatppuccinMocha.orange)
        .style(.{ .italic, .strikethrough })
        .run();
}

```
