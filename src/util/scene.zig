const std = @import("std");
const c = @import("../lib/c.zig").c;

pub const Entity = struct {
    ptr: *anyopaque,
    renderFn: *const fn (*anyopaque, *c.SDL_Renderer) void,
    destroyFn: *const fn (*anyopaque, std.mem.Allocator) void,

    pub fn render(self: Entity, renderer: *c.SDL_Renderer) void {
        self.renderFn(self.ptr, renderer);
    }

    pub fn destroy(self: Entity, allocator: std.mem.Allocator) void {
        self.destroyFn(self.ptr, allocator);
    }
};

pub const SceneName = enum {
    main_menu,
    game,
};

pub const Scene = struct {
    name: SceneName,
    entities: std.ArrayList(Entity),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, name: SceneName) Scene {
        return .{
            .name = name,
            .entities = std.ArrayList(Entity){},
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Scene) void {
        // Clean up all entities
        for (self.entities.items) |component| {
            component.destroy(self.allocator);
        }
        self.entities.deinit(self.allocator);
    }

    pub fn add(self: *Scene, component: anytype) !void {
        const T = @TypeOf(component);

        // Allocate and copy the component
        const ptr = try self.allocator.create(T);
        ptr.* = component;

        // Create wrapper functions
        const Wrapper = struct {
            fn render(p: *anyopaque, renderer: *c.SDL_Renderer) void {
                const self_ptr: *T = @ptrCast(@alignCast(p));
                self_ptr.render(renderer);
            }

            fn destroy(p: *anyopaque, allocator: std.mem.Allocator) void {
                const self_ptr: *T = @ptrCast(@alignCast(p));

                // Call deinit if it exists
                if (@hasDecl(T, "deinit")) {
                    self_ptr.deinit(allocator);
                }

                // Free the memory
                allocator.destroy(self_ptr);
            }
        };

        try self.entities.append(self.allocator, Entity{
            .ptr = ptr,
            .renderFn = Wrapper.render,
            .destroyFn = Wrapper.destroy,
        });
    }

    pub fn render(self: *Scene, renderer: *c.SDL_Renderer) void {
        for (self.entities.items) |entity| {
            entity.render(renderer);
        }
    }
};
