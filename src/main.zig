const std = @import("std");
const sdl = @import("util/sdl.zig");
const c = @import("lib/c.zig").c;
const s = @import("structs/shape.zig");
const SceneManager = @import("structs/scene-manager.zig").SceneManager;
const Timer = @import("structs/timer.zig").Timer;

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
    var timer = Timer.init();
    var running = true;

    while (running) {
        const delta = timer.delta();

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

        std.debug.print("Delta: {d:.4}s FPS: {d:.1}\n", .{ delta, 1.0 / delta });
    }
}
