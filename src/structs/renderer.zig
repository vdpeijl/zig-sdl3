const std = @import("std");
const tf = @import("transform.zig");
const c = @import("../lib/c.zig").c;
const s = @import("shape.zig");

pub const ShapeRenderer2D = struct {
    transform: tf.Transform2D = .{ .x = 0, .y = 0, .rotation = 0 },
    shape: s.Shape,

    pub fn render(self: ShapeRenderer2D, renderer: *c.struct_SDL_Renderer) void {
        switch (self.shape) {
            .circle => std.debug.print("circle\n", .{}),
            .square => {
                var square = c.SDL_FRect{
                    .x = self.transform.x,
                    .y = self.transform.y,
                    .w = self.shape.square.?.side,
                    .h = self.shape.square.?.side,
                };

                _ = c.SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
                _ = c.SDL_RenderFillRect(renderer, &square);
                _ = c.SDL_RenderPresent(renderer);
            },
            .rectangle => std.debug.print("rectangle\n", .{}),
        }
    }
};
