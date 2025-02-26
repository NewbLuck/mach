const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&testStep(b, mode, target).step);
}

pub fn testStep(b: *std.build.Builder, mode: std.builtin.Mode, target: std.zig.CrossTarget) *std.build.RunStep {
    const main_tests = b.addTestExe("ecs-tests", (comptime thisDir()) ++ "/src/main.zig");

    // TODO(self-hosted): remove this when tests passed with self-hosted compiler
    main_tests.use_stage1 = true;

    main_tests.setBuildMode(mode);
    main_tests.setTarget(target);
    main_tests.install();
    return main_tests.run();
}

pub const pkg = std.build.Pkg{
    .name = "ecs",
    .source = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = &[_]std.build.Pkg{},
};

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}
