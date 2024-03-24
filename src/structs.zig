const std = @import("std");

pub const Config = struct {
    sx_folder: []const u8,
    allocator: std.mem.Allocator,
    it: *std.process.ArgIterator,
};

pub const JsonServer = struct {
    server_name: []const u8,
    ip: []const u8,
    port: []const u8,
    login: []const u8,
    password: []const u8,
};
