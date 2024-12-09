const input = @embedFile("data/day1.txt");
const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    try part1();
    try part2();
}

fn part1() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var array1: [1000]i32 = undefined;
    var array2: [1000]i32 = undefined;
    var index: usize = 0;

    while (it.next()) |token| {
        const first = try std.fmt.parseInt(i32, token[0..5], 10);
        const second = try std.fmt.parseInt(i32, token[8..13], 10);
        array1[index] = first;
        array2[index] = second;
        index += 1;
    }
    std.mem.sort(i32, &array1, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, &array2, {}, comptime std.sort.asc(i32));

    var counter: i32 = 0;
    for (0.., array1) |i, _| {
        if (array1[i] >= array2[i]) counter += (array1[i] - array2[i]) else counter += (array2[i] - array1[i]);
    }
    print("Ergebnis Teil 1: {d}\n", .{counter});
}

fn part2() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var array1: [1000]usize = undefined;
    var array2: [1000]usize = undefined;
    var index: usize = 0;

    while (it.next()) |token| {
        const first = try std.fmt.parseInt(usize, token[0..5], 10);
        const second = try std.fmt.parseInt(usize, token[8..13], 10);
        array1[index] = first;
        array2[index] = second;
        index += 1;
    }

    var counter: usize = 0;

    for (array1) |elem1| {
        for (array2) |elem2| {
            if (elem1 == elem2) counter += elem2;
        }
    }
    print("Ergebnis Teil 2: {d}\n", .{counter});
}
