const std = @import("std");
const c = @cImport({
    @cInclude("raylib.h");
});

pub fn main() void {
    c.SetConfigFlags(c.FLAG_WINDOW_RESIZABLE | c.FLAG_VSYNC_HINT);
    c.InitWindow(800, 600, "Test App");
    defer c.CloseWindow();

    const arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    _ = allocator;

    const textures = std.ArrayList(c.Texture2D);
    defer {
        for (textures) |texture| {
            c.UnloadTexture(texture);
        }
    }

    while (!c.WindowShouldClose()) {
        if (c.IsFileDropped()) {
            const files = c.LoadDroppedFiles();
            defer c.UnloadDroppedFiles(files);

            const paths = files.paths[0..files.count];
            for (paths) |file_path| {
                std.debug.print("{s}\n", .{file_path});
            }
        }

        {
            c.BeginDrawing();
            defer c.EndDrawing();
        }
    }
}
