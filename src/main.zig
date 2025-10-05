const std = @import("std");
const sdl = @import("util/sdl.zig");
const c = @cImport({
    @cInclude("SDL3/SDL.h");
});

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

    const renderer = c.SDL_CreateRenderer(window, null);
    defer c.SDL_DestroyRenderer(renderer);

    // Simple event loop
    var running = true;
    while (running) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event)) {
            if (event.type == c.SDL_EVENT_QUIT) {
                running = false;
            }
        }
        c.SDL_Delay(16); // ~60 FPS

        _ = c.SDL_SetRenderDrawColor(renderer, 30, 30, 30, 255);
        _ = c.SDL_RenderClear(renderer);

        var width: c_int = 0;
        var height: c_int = 0;

        _ = c.SDL_GetWindowSize(window, &width, &height);

        const square = c.SDL_FRect{
            .x = @floatFromInt(@divFloor(width, 2)),
            .y = @floatFromInt(@divFloor(height, 2)),
            .w = 200,
            .h = 200,
        };

        _ = c.SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
        _ = c.SDL_RenderFillRect(renderer, &square);

        _ = c.SDL_RenderPresent(renderer);
    }
}
