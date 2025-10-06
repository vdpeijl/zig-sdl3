const std = @import("std");
const sdl = @import("util/sdl.zig");
const c = @import("lib/c.zig").c;
const s = @import("structs/shape.zig");
const SceneManager = @import("structs/scene-manager.zig").SceneManager;

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

    var scene_manager = try SceneManager.init();

    var last_time = c.SDL_GetPerformanceCounter();
    const perf_frequency = @as(f64, @floatFromInt(c.SDL_GetPerformanceFrequency()));
    var running = true;

    // Simple event loop
    while (running) {
        const current_time = c.SDL_GetPerformanceCounter();
        const delta = @as(f32, @floatCast(@as(f64, @floatFromInt(current_time - last_time)) / perf_frequency));
        last_time = current_time;

        std.debug.print("Delta: {d:.4}s FPS: {d:.1}\n", .{ delta, 1.0 / delta });

        scene_manager.update(delta);
        scene_manager.render(renderer);

        _ = c.SDL_RenderPresent(renderer);

        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event)) {
            if (event.type == c.SDL_EVENT_QUIT) {
                running = false;
            }

            scene_manager.handleEvent(&event);
        }
    }
}
