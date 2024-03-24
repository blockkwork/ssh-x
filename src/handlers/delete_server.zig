const structs = @import("../structs.zig");
const showHelp = @import("../cmd.zig").showHelp;
const std = @import("std");

pub fn deleteServer(c: structs.Config) void {
    const server_name = c.it.next() orelse {
        std.log.err("Invalid args for 'delete' command", .{});
        showHelp();
    };

    const path = std.mem.join(c.allocator, "", &.{ c.sx_folder, "/", server_name, ".json" }) catch |err| {
        std.log.err("mem.join error: {}\n", .{err});
        std.process.exit(1);
    };

    std.fs.cwd().deleteFile(path) catch |err| switch (err) {
        error.FileNotFound => {
            std.log.err("The server has already been deleted", .{});
            return;
        },
        else => {
            std.log.err("deleteFile error: {}", .{err});
            std.process.exit(1);
        },
    };

    std.log.info("Server deleted", .{});
}
