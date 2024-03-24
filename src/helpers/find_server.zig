const std = @import("std");
const fs = std.fs;
const JsonServer = @import("../structs.zig").JsonServer;

pub fn findServer(path: []const u8, allocator: std.mem.Allocator) std.json.ParseError(std.json.Scanner)!std.json.Parsed(JsonServer) {
    const data = fs.cwd().readFileAlloc(allocator, path, 1024) catch |err| switch (err) {
        error.FileNotFound => {
            std.log.err("Server not found\n", .{});
            std.process.exit(1);
        },
        else => {
            std.log.err("readFileAlloc error: {}", .{err});
            std.process.exit(1);
        },
    };
    defer allocator.free(data);
    return std.json.parseFromSlice(JsonServer, allocator, data, .{ .allocate = .alloc_always });
}
