const std = @import("std");
const r = @import("../structs/renderer.zig");
const shape = @import("../structs/shape.zig");
const c = @import("../lib/c.zig").c;

pub const StartScene = struct {
    square: r.ShapeRenderer(shape.Square),

    pub fn init() !StartScene {
        return StartScene{
            .square = r.ShapeRenderer(shape.Square){
                .shape = .{ .side = 200 },
                .transform = .{ .x = 100, .y = 100 },
            },
        };
    }

    pub fn update(self: *StartScene, delta: f32) void {
        self.square.transform.x += delta * 100;
    }

    pub fn render(self: *StartScene, renderer: *c.SDL_Renderer) void {
        self.square.render(renderer);
    }
};
