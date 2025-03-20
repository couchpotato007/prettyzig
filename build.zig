const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const root_source_file = b.path("src/pretty.zig");

    // Module
    const pretty_mod = b.addModule("prettyzig", .{
        .root_source_file = root_source_file,
        .target = target,
        .optimize = optimize,
    });

    // Test
    const test_step = b.step("test", "Run all tests in all modes.");
    const tests = b.addTest(.{
        .root_source_file = root_source_file,
        .target = target,
        .optimize = optimize,
    });
    const run_tests = b.addRunArtifact(tests);
    test_step.dependOn(&run_tests.step);

    // Examples
    const Example = enum {
        hello_world,
        color_pallete,
    };
    const example_option = b.option(Example, "example", "Example to run (default: hello_world)") orelse .hello_world;
    const example_step = b.step("example", "Run example");
    const example = b.addExecutable(.{
        .name = "example",
        .root_source_file = b.path(
            b.fmt("example/{s}.zig", .{@tagName(example_option)}),
        ),
        .target = target,
        .optimize = optimize,
    });
    example.root_module.addImport("prettyzig", pretty_mod);

    const example_run = b.addRunArtifact(example);
    example_step.dependOn(&example_run.step);

    // Docs
    const docs_step = b.step("docs", "Build docs");
    const docs_obj = b.addObject(.{
        .name = "prettyzig",
        .root_source_file = root_source_file,
        .target = target,
        .optimize = optimize,
    });
    const docs = docs_obj.getEmittedDocs();
    docs_step.dependOn(&b.addInstallDirectory(.{
        .source_dir = docs,
        .install_dir = .prefix,
        .install_subdir = "docs",
    }).step);

    // README
    const readme_step = b.step("readme", "Remake README.");
    const readme = readMeStep(b);
    readme_step.dependOn(readme);

    // ALL
    const all_step = b.step("all", "Build everything and runs all tests");
    all_step.dependOn(test_step);
    all_step.dependOn(readme_step);
    all_step.dependOn(test_step);

    b.default_step.dependOn(all_step);
}

fn readMeStep(b: *std.Build) *std.Build.Step {
    const s = b.allocator.create(std.Build.Step) catch unreachable;
    s.* = std.Build.Step.init(.{
        .id = .custom,
        .name = "ReadMeStep",
        .owner = b,
        .makeFn = struct {
            fn make(step: *std.Build.Step, _: std.Build.Step.MakeOptions) anyerror!void {
                @setEvalBranchQuota(10000);
                _ = step;
                const file = try std.fs.cwd().createFile("README.md", .{});
                const stream = file.writer();
                try stream.print(@embedFile("example/README_template.md"), .{
                    @embedFile("example/hello_world.zig"),
                    @embedFile("example/color_pallete.zig"),
                });
            }
        }.make,
    });
    return s;
}
