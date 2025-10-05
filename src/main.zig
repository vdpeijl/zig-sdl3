const std = @import("std");
const sdl = @import("util/sdl.zig");
const r = @import("structs/renderer.zig");
const c = @import("lib/c.zig").c;
const s = @import("structs/shape.zig");
const startScene = @import("scenes/start.zig");
const Scene = @import("util/scene.zig").Scene;
const SceneName = @import("util/scene.zig").SceneName;

pub fn main() !void {
    if (!c.SDL_Init(c.SDL_INIT_VIDEO)) {
        std.debug.print("SDL_Init failed: {s}\n", .{c.SDL_GetError()});
    }

    defer c.SDL_Quit();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

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

    var s_start = Scene.init(allocator, SceneName.main_menu);
    defer s_start.deinit();
    try startScene.init(&s_start);

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

        s_start.render(renderer);

        _ = c.SDL_RenderPresent(renderer);

        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event)) {
            if (event.type == c.SDL_EVENT_QUIT) {
                running = false;
            }
        }

        c.SDL_Delay(16); // ~60 FPS
    }
}
