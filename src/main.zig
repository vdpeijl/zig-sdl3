const std = @import("std");
const sdl = @import("util/sdl.zig");
const r = @import("structs/renderer.zig");
const c = @import("lib/c.zig").c;
const s = @import("structs/shape.zig");

const WINDOW_WIDTH: c_int = 800;
const WINDOW_HEIGHT: c_int = 600;

pub fn main() !void {
    if (!c.SDL_Init(c.SDL_INIT_VIDEO)) {
        std.debug.print("SDL_Init failed: {s}\n", .{c.SDL_GetError()});
    }

    defer c.SDL_Quit();

    // const bounds = try sdl.get_bounds();
    const window = c.SDL_CreateWindow(
        "Hello SDL3",
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        c.SDL_WINDOW_RESIZABLE,
    ) orelse {
        std.debug.print("SDL_CreateWindow failed: {s}\n", .{c.SDL_GetError()});
        return error.WindowCreationFailed;
    };
    defer c.SDL_DestroyWindow(window);

    const renderer = c.SDL_CreateRenderer(window, null) orelse {
        std.debug.print("SDL_CreateRenderer failed: {s}\n", .{c.SDL_GetError()});
        return error.RendererCreationFailed;
    };
    defer c.SDL_DestroyRenderer(renderer);

    // Simple event loop
    var running = true;
    while (running) {
        c.SDL_Delay(16); // ~60 FPS

        var square = r.ShapeRenderer2D{ .shape = s.Shape{ .square = .{ .side = 200 } } };
        square.render(renderer);

        std.debug.print("{any}\n", .{square});

        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event)) {
            if (event.type == c.SDL_EVENT_QUIT) {
                running = false;
            } else if (event.type == c.SDL_EVENT_KEY_DOWN) {
                const key = c.SDL_GetKeyName(event.key.key);
                std.debug.print("Key pressed: {s}\n", .{key});

                // Check for specific keys
                if (event.key.key == c.SDLK_ESCAPE) {
                    running = false;
                }

                if (event.key.key == c.SDLK_W) {
                    square.transform.x += 1;
                }
            }
        }
    }
}
