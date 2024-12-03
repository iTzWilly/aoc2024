const std = @import("std");
const input = @embedFile("data/day3.txt");

pub fn main() !void {
    try part1();
    try part2();
}

fn compute(lines: []const u8) u32 {
    var result: u32 = 0;
    var it = std.mem.tokenizeSequence(u8, lines, "mul(");

    while (it.next()) |token| {
        var numbers = std.mem.tokenizeScalar(u8, token, ',');
        // while (index.)
        const num1 = numbers.next();
        var num2_it = std.mem.tokenizeScalar(u8, numbers.rest(), ')');
        const num2 = num2_it.next();
        const n1 = std.fmt.parseInt(u32, num1.?, 10) catch continue;
        const n2 = std.fmt.parseInt(u32, num2.?, 10) catch continue;

        result += (n1 * n2);
    }
    return result;
}

fn part1() !void {
    std.debug.print("Ergebnis von Teil 1: {d}\n", .{compute(input)});
}

fn part2() !void {
    var result: u32 = 0;
    var it = std.mem.tokenizeSequence(u8, input, "do");
    var enabled = true;

    while (it.next()) |token| {
        if (std.mem.startsWith(u8, token, "()")) enabled = true;
        if (std.mem.startsWith(u8, token, "n't()")) enabled = false;
        if (enabled) result += compute(token);
    }
    std.debug.print("Ergebnis von Teil 2: {d}\n", .{result});
}
