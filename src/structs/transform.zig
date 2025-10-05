pub const Transform2D = struct {
    x: f32 = 0,
    y: f32 = 0,

    rotation: f32 = 0,

    pub fn rotate(self: Transform2D, deg: f32) void {
        self.rotation = deg;
    }
};
