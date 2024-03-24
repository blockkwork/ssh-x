const std = @import("std");
const structs = @import("../structs.zig");
const process = std.process;
const showHelp = @import("../cmd.zig").showHelp;

pub fn handleAddServer(c: structs.Config) void {
    // parse (server_name login:password@127.0.0.1:22)
    const cli_server_name = c.it.next() orelse {
        std.log.err("Invalid args for 'add-server' command\n", .{});
        showHelp();
    };

    const cli_server = c.it.next() orelse {
        std.log.err("Invalid args for 'add-server' command\n", .{});
        showHelp();
    };

    var json_server = std.mem.zeroes(structs.JsonServer);
    json_server.server_name = cli_server_name;

    var res = std.mem.split(u8, cli_server, ":");
    var i: i8 = 0;
    while (res.next()) |x| {
        switch (i) {
            0 => {
                json_server.login = x;
            },
            1 => {
                var other = std.mem.splitSequence(u8, x, "@");
                json_server.password = other.first();

                json_server.ip = other.next() orelse {
                    std.log.err("Invalid password@ip: {s}", .{x});
                    process.exit(1);
                };
            },
            2 => {
                json_server.port = x;
            },
            else => {},
        }
        i += 1;
    }

    const server_path = std.mem.join(c.allocator, "", &.{ c.sx_folder, "/", json_server.server_name, ".json" }) catch |err| {
        std.log.err("mem.join error: {}", .{err});
        process.exit(1);
    };

    var file = std.fs.cwd().createFile(server_path, .{}) catch |err| {
        std.log.err("Can't create file: {}", .{err});
        process.exit(1);
    };
    defer file.close();

    std.json.stringify(json_server, std.json.StringifyOptions{}, file.writer()) catch |err| {
        std.log.err("Stringify error: {}", .{err});
        process.exit(1);
    };

    std.log.info("Server saved: {s}\n", .{server_path});
    c.allocator.free(server_path);
}
