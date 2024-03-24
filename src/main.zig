const std = @import("std");
const cmd = @import("cmd.zig").cmd;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var it = try std.process.ArgIterator.initWithAllocator(allocator);
    defer it.deinit();

    _ = it.skip(); // exe name

    cmd(it, allocator);
}
