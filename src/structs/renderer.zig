const std = @import("std");
const t = @import("transform.zig");
const c = @import("../lib/c.zig").c;
const s = @import("shape.zig");

pub fn ShapeRenderer(comptime ShapeType: type) type {
    return struct {
        transform: t.Transform2D = .{ .x = 0, .y = 0 },
        shape: ShapeType,

        pub fn render(self: @This(), renderer: *c.SDL_Renderer) void {
            if (ShapeType == s.Square) {
                const rect = c.SDL_FRect{
                    .x = self.transform.x,
                    .y = self.transform.y,
                    .w = self.shape.side,
                    .h = self.shape.side,
                };
                _ = c.SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
                _ = c.SDL_RenderFillRect(renderer, &rect);
            } else if (ShapeType == s.Rectangle) {
                const rect = c.SDL_FRect{
                    .x = self.transform.x,
                    .y = self.transform.y,
                    .w = self.shape.width,
                    .h = self.shape.height,
                };
                _ = c.SDL_SetRenderDrawColor(renderer, 0, 255, 0, 255);
                _ = c.SDL_RenderFillRect(renderer, &rect);
            }
        }
    };
}
