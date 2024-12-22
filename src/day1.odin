package aoc2024

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:sort"


main :: proc() {
    data, ok := os.read_entire_file("data/day1.txt", context.allocator)
    if !ok {
        // file is missing
        return
    }
    defer delete(data, context.allocator)
    it := string(data)
    list_a : [dynamic]int
    list_b : [dynamic]int
    defer delete(list_a)
    defer delete(list_b)
    for line in strings.split_lines_iterator(&it) {
        ab := strings.split(line, "   ")
        append(&list_a, strconv.atoi(ab[0]))
        append(&list_b, strconv.atoi(ab[1]))
    }

    sort.quick_sort(list_a[:])
    sort.quick_sort(list_b[:])

    result := 0
    for i := 0; i < len(list_a); i += 1 {
        if (list_a[i] >= list_b[i]) {
            result += (list_a[i] - list_b[i])
        } else {
            result += (list_b[i] - list_a[i])
        }
    }

    fmt.printf("Ergebnis Teil 1: %d\n", result)



}

