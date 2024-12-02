const std = @import("std");
const print = std.debug.print;
const input = @embedFile("data/day2.txt");

pub fn main() !void {
    try part1();
    try part2();
}

fn safeList(levels: []i32) bool {
    var prev = levels[0];

    var incr = false;
    var decr = false;

    for (levels[1..]) |curr| {
        if (@abs(curr - prev) > 3) {
            return false;
        }

        if (curr > prev) {
            if (decr) {
                return false;
            }
            incr = true;
        } else if (curr < prev) {
            if (incr) {
                return false;
            }
            decr = true;
        } else {
            return false;
        }

        prev = curr;
    }

    return true;
}

fn part1() !void {
    // Allocator for Memory
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var feld = try std.ArrayList(i32).initCapacity(allocator, 10);
    defer feld.deinit();

    var iter = std.mem.tokenizeScalar(u8, input, '\n');
    var safe: i32 = 0;

    while (iter.next()) |line| {
        feld.clearAndFree();
        var inner = std.mem.split(u8, line, " ");

        while (inner.next()) |value| {
            const number = try std.fmt.parseInt(i32, value, 10);
            try feld.append(number);
        }

        if (safeList(feld.items)) safe += 1;
    }
    print("Ergebnis Teil 1: {d}\n", .{safe});
}

fn part2() !void {
    // Allocator for Memory
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var feld = try std.ArrayList(i32).initCapacity(allocator, 10);
    defer feld.deinit();

    var iter = std.mem.tokenizeScalar(u8, input, '\n');
    var safe: i32 = 0;

    while (iter.next()) |line| {
        feld.clearAndFree();
        var inner = std.mem.split(u8, line, " ");

        while (inner.next()) |value| {
            const number = try std.fmt.parseInt(i32, value, 10);
            try feld.append(number);
        }

        for (0..feld.items.len) |index| {
            var klein_feld = try feld.clone();
            _ = klein_feld.orderedRemove(index);
            if (safeList(klein_feld.items)) {
                safe += 1;
                break;
            }
        }
    }
    print("Ergebnis Teil 2: {d}\n", .{safe});
}
