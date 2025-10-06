const c = @import("../lib/c.zig").c;

pub const Timer = struct {
    last_time: u64 = 0,
    perf_frequency: f64,

    pub fn init() Timer {
        return .{
            .perf_frequency = @as(f64, @floatFromInt(c.SDL_GetPerformanceFrequency())),
        };
    }

    pub fn delta(self: *Timer) f32 {
        const current_time = c.SDL_GetPerformanceCounter();
        defer self.last_time = current_time;

        if (self.last_time == 0) {
            self.last_time = current_time;
            return 0.0;
        }

        return @as(f32, @floatCast(@as(f64, @floatFromInt(current_time - self.last_time)) / self.perf_frequency));
    }
};
