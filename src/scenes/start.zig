const std = @import("std");
const s = @import("../util/scene.zig");
const r = @import("../structs/renderer.zig");
const shape = @import("../structs/shape.zig");
const Scene = s.Scene;

pub fn init(scene: *Scene) !void {
    try scene.add(r.ShapeRenderer(shape.Square){
        .shape = .{ .side = 200 },
        .transform = .{ .x = 100, .y = 100 },
    });
}
