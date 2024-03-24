const structs = @import("../structs.zig");

const std = @import("std");

pub fn handleList(c: structs.Config) void {
    std.debug.print("{s}\n", .{c.sx_folder});
    var dir = std.fs.openDirAbsolute(c.sx_folder, .{ .iterate = true }) catch |err| {
        std.debug.print("{}", .{err});
        std.process.exit(1);
    };

    var iterator = dir.iterate();

    while (iterator.next() catch |err| {
        std.debug.print("{}", .{err});
        std.process.exit(1);
    }) |x| {
        if (x.name.len < 5) {
            continue;
        }
        std.debug.print("{s}\n", .{x.name[0 .. x.name.len - 5]});
    }
}
