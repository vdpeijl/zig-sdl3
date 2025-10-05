pub const Circle = struct {
    radius: f32,
    pub fn area(self: Circle) f32 {
        return 3.14159 * self.radius * self.radius;
    }
};

pub const Rectangle = struct {
    width: f32,
    height: f32,
    pub fn area(self: Rectangle) f32 {
        return self.width * self.height;
    }
};

pub const Square = struct {
    side: f32,
    pub fn area(self: Square) f32 {
        return self.side * self.side;
    }
};

pub const Shape = union(enum) {
    circle: Circle,
    rectangle: Rectangle,
    square: Square,
};

pub fn square(side: f32) Shape {
    return Shape{ .square = Square{ .side = side } };
}

pub fn circle(radius: f32) Shape {
    return Shape{ .circle = Circle{ .radius = radius } };
}

pub fn rectangle(width: f32, height: f32) Shape {
    return Shape{ .rectangle = Rectangle{ .width = width, .height = height } };
}
