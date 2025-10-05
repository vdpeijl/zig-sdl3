const std = @import("std");
const c = @import("../lib/c.zig").c;

pub fn get_bounds() !c.SDL_Rect {
    const primary_display = c.SDL_GetPrimaryDisplay();
    var bounds: c.SDL_Rect = undefined;
    if (!c.SDL_GetDisplayBounds(primary_display, &bounds)) {
        std.debug.print("Failed to get display bounds: {s}\n", .{c.SDL_GetError()});
        return error.GetDisplayBoundsFailed;
    }
    return bounds;
}
