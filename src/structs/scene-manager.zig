const std = @import("std");
const c = @import("../lib/c.zig").c;
const MenuScene = @import("../scenes/menu.zig").MenuScene;

const SceneType = union(enum) {
    menu: MenuScene,

    pub fn update(self: *SceneType, delta: f32) void {
        switch (self.*) {
            inline else => |*scene| {
                const T = @TypeOf(scene.*);
                if (@hasDecl(T, "update")) {
                    scene.update(delta);
                }
            },
        }
    }

    pub fn render(self: *SceneType, renderer: *c.SDL_Renderer) void {
        switch (self.*) {
            inline else => |*scene| {
                const T = @TypeOf(scene.*);
                if (@hasDecl(T, "render")) {
                    scene.render(renderer);
                }
            },
        }
    }

    pub fn handleEvent(self: *SceneType, event: *c.SDL_Event) void {
        switch (self.*) {
            inline else => |*scene| {
                const T = @TypeOf(scene.*);
                if (@hasDecl(T, "handleEvent")) {
                    scene.handleEvent(event);
                }
            },
        }
    }
};

pub const SceneManager = struct {
    current_scene: SceneType,

    pub fn init() !SceneManager {
        return SceneManager{
            .current_scene = .{ .menu = try MenuScene.init() },
        };
    }

    pub fn update(self: *SceneManager, delta: f32) void {
        self.current_scene.update(delta);
    }

    pub fn render(self: *SceneManager, renderer: *c.SDL_Renderer) void {
        self.current_scene.render(renderer);
    }

    pub fn handleEvent(self: *SceneManager, event: *c.SDL_Event) void {
        self.current_scene.handleEvent(event);
    }

    // usage: scene_manager.switchScene(.menu);
    pub fn switchScene(self: *SceneManager, comptime scene_tag: std.meta.Tag(SceneType)) !void {
        switch (scene_tag) {
            .menu => {
                self.current_scene = .{ .menu = try MenuScene.init() };
            },
        }
    }
};
