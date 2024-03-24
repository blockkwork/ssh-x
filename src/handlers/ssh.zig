const std = @import("std");
const structs = @import("../structs.zig");
const process = std.process;
const showHelp = @import("../cmd.zig").showHelp;
const findServer = @import("../helpers/find_server.zig").findServer;

pub fn handleSsh(c: structs.Config) void {
    const server_name = c.it.next() orelse {
        std.log.err("Invalid args for 'ssh' command\n", .{});
        showHelp();
    };

    const path = std.mem.join(c.allocator, "", &.{ c.sx_folder, "/", server_name, ".json" }) catch |err| {
        std.log.err("mem.join error: {}\n", .{err});
        process.exit(1);
    };

    const json_server = findServer(path, c.allocator) catch |err| {
        std.log.err("findServer error: {}\n", .{err});
        return;
    };

    const conc = std.mem.concat(c.allocator, u8, &.{ json_server.value.login, "@", json_server.value.ip }) catch |err| {
        std.log.err("mem.concat error: {}", .{err});
        process.exit(1);
    };

    const argv = &[_][]const u8{ "sshpass", "-p", json_server.value.password, "ssh", conc, "-p", json_server.value.port };

    var p = std.ChildProcess.init(argv, c.allocator);
    _ = p.spawnAndWait() catch |err| {
        std.log.err("spawn error: {}", .{err});
        process.exit(1);
    };
}
