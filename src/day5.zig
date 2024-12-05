const std = @import("std");
const file = @embedFile("data/day5.txt");

var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);

pub fn main() !void {
    std.debug.print("Ergebnis von Teil 1: {}\n", .{try part1(file)});
    std.debug.print("Ergebnis von Teil 2: {}\n", .{try part2(file)});

    aa.deinit();
}

const SortData = struct {
    comparisons: []const [2]u8,
    books: [][]u8,
    sorted_books: [][]u8,
};

fn init(input: []const u8) !SortData {
    var comparisons = std.ArrayList([2]u8).init(aa.allocator());
    var books = std.ArrayList([]u8).init(aa.allocator());
    var sorted_books = std.ArrayList([]u8).init(aa.allocator());

    var inputIter = std.mem.tokenizeAny(u8, input, "|\n");
    var line = inputIter.next();
    while (line) |_| : (line = inputIter.next()) {
        const n1 = std.fmt.parseInt(u8, line.?, 10) catch break;
        line = inputIter.next();
        const n2 = std.fmt.parseInt(u8, line.?, 10) catch unreachable;
        try comparisons.append(.{ n1, n2 });
    }
    while (line) |l| : (line = inputIter.next()) {
        var numIter = std.mem.tokenizeScalar(u8, l, ',');
        var pages = std.ArrayList(u8).init(aa.allocator());
        var sorted_pages = std.ArrayList(u8).init(aa.allocator());
        while (numIter.next()) |n| {
            const num = try std.fmt.parseInt(u8, n, 10);
            try pages.append(num);
            try sorted_pages.append(num);
        }
        try books.append(try pages.toOwnedSlice());
        try sorted_books.append(try sorted_pages.toOwnedSlice());
    }
    return SortData{
        .books = try books.toOwnedSlice(),
        .sorted_books = try sorted_books.toOwnedSlice(),
        .comparisons = try comparisons.toOwnedSlice(),
    };
}

fn bookOrder(context: []const [2]u8, a: u8, b: u8) bool {
    var idx: usize = undefined;
    for (context, 0..) |pair, i| {
        if ((a == pair[0] and b == pair[1]) or
            (a == pair[1] and b == pair[0]))
        {
            idx = i;
            break;
        }
        if (i == context.len - 1) unreachable;
    }
    if (context[idx][0] == a) return true else return false;
}

fn part1(input: []const u8) !usize {
    const data = try init(input);

    for (data.sorted_books) |*s| {
        std.mem.sort(u8, s.*, data.comparisons, bookOrder);
    }

    var sum: usize = 0;
    for (data.books, data.sorted_books) |b, s| {
        if (std.mem.eql(u8, b, s))
            sum += b[b.len / 2];
    }
    return sum;
}

fn part2(input: []const u8) !usize {
    const data = try init(input);

    for (data.sorted_books) |*s| {
        std.mem.sort(u8, s.*, data.comparisons, bookOrder);
    }

    var sum: usize = 0;
    for (data.books, data.sorted_books) |b, s| {
        if (!std.mem.eql(u8, b, s))
            sum += s[s.len / 2];
    }
    return sum;
}
