const std = @import("std");
const process = @import("std").process;
const structs = @import("./structs.zig");

const Config = structs.Config;
const JsonServer = structs.JsonServer;

const ServersFolder = ".config/.sx";
const addServer = @import("./handlers/add_server.zig").handleAddServer;
const ssh = @import("./handlers/ssh.zig").handleSsh;
const deleteServer = @import("./handlers/delete_server.zig").deleteServer;
const handleList = @import("./handlers/list.zig").handleList;

const Commands = enum {
    @"--list",
    @"-l",
    @"--delete",
    @"-d",
    @"--ssh",
    @"-s",
    @"--add-server",
    @"-a",
    @"--help",
    @"-h",
};

pub fn cmd(__it: process.ArgIterator, allocator: std.mem.Allocator) void {
    var it: *process.ArgIterator = @constCast(&__it);

    const command = command: {
        const subc_string = it.next() orelse showHelp();

        break :command std.meta.stringToEnum(Commands, subc_string) orelse {
            std.debug.print("Invalid subcommand: {s}\n\n", .{subc_string});
            showHelp();
        };
    };

    const home = std.os.getenv("HOME") orelse {
        std.debug.print("Can't get HOME", .{});
        process.exit(1);
    };

    const path = std.mem.join(allocator, "/", &.{ home, ServersFolder }) catch |err| {
        std.debug.print("{}", .{err});
        return;
    };
    defer allocator.free(path);

    std.fs.cwd().makeDir(path) catch |err| switch (err) {
        error.PathAlreadyExists => {},
        else => {
            std.log.err("Can't create .sx folder: {}", .{err});
        },
    };

    const config: Config = .{ .allocator = allocator, .it = it, .sx_folder = path };

    switch (command) {
        .@"--help", .@"-h" => showHelp(),
        .@"-a", .@"--add-server" => addServer(config),
        .@"-s", .@"--ssh" => ssh(config),
        .@"--delete", .@"-d" => deleteServer(config),
        .@"--list", .@"-l" => handleList(config),
    }
}

pub fn showHelp() noreturn {
    std.log.err(
        \\Available commands: --add-server (-a), --ssh (-s), --delete (-d)
        \\
        \\Examples:
        \\  sx -a server_name root:password@127.0.0.1:22
        \\  sx -s server_name 
        \\  sx -d server_name
        \\
    , .{});
    process.exit(1);
}
