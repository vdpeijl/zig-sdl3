const std = @import("std");
const sdl = @import("util/sdl.zig");
const r = @import("structs/renderer.zig");
const c = @import("lib/c.zig").c;
const s = @import("structs/shape.zig");

pub fn main() !void {
    if (!c.SDL_Init(c.SDL_INIT_VIDEO)) {
        std.debug.print("SDL_Init failed: {s}\n", .{c.SDL_GetError()});
    }

    defer c.SDL_Quit();

    const window = c.SDL_CreateWindow(
        "Hello SDL3",
        800,
        600,
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

    var square = r.ShapeRenderer(s.Square){ .shape = .{ .side = 200 } };
    var rect = r.ShapeRenderer(s.Rectangle){ .shape = .{ .width = 100, .height = 200 }, .transform = .{ .x = 300, .y = 300 } };

    var last_time = c.SDL_GetPerformanceCounter();
    const perf_frequency = @as(f64, @floatFromInt(c.SDL_GetPerformanceFrequency()));
    var running = true;

    // Simple event loop
    while (running) {
        const current_time = c.SDL_GetPerformanceCounter();
        const delta = @as(f32, @floatCast(@as(f64, @floatFromInt(current_time - last_time)) / perf_frequency));
        last_time = current_time;

        std.debug.print("Delta: {d:.4}s FPS: {d:.1}\n", .{ delta, 1.0 / delta });

        // Clear the screen each frame (black background)
        _ = c.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        _ = c.SDL_RenderClear(renderer);

        square.render(renderer);
        rect.render(renderer);

        _ = c.SDL_RenderPresent(renderer);

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

                if (event.key.key == c.SDLK_D) {
                    square.transform.x += delta * 300;
                }

                if (event.key.key == c.SDLK_A) {
                    square.transform.x -= delta * 300;
                }

                if (event.key.key == c.SDLK_W) {
                    square.transform.y -= delta * 300;
                }

                if (event.key.key == c.SDLK_S) {
                    square.transform.y += delta * 300;
                }
            }
        }

        c.SDL_Delay(16); // ~60 FPS
    }
}
