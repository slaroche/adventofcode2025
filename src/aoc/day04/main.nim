import commons/utils
import commons/timeit
import os
import strutils
import sequtils
import sugar


proc reduce(grid: seq[seq[char]]): tuple[total: int, grid: seq[seq[char]]] =
    var 
        total = 0
        newGrid: seq[seq[char]] = @[@[]]

    for y in 0..<grid.len:
        newGrid.add(@[])
        for x in 0..<grid[y].len:
            if grid[y][x] != '@':
                newGrid[y].add('.')
                continue
            let adjacent = [
                (x - 1, y - 1),
                (x, y - 1),
                (x + 1, y - 1),
                (x - 1, y),
                (x + 1, y),
                (x - 1, y + 1),
                (x, y + 1),
                (x + 1, y + 1),
            ]
            var count = 0
            for (x, y) in adjacent:
                if x < 0 or y < 0 or y >= grid.len or x >= grid[y].len:
                    continue
                if grid[y][x] == '@':
                    count += 1
            if count < 4:
                total += 1
                newGrid[y].add('.')
            else:
                newGrid[y].add('@')
    return (total, newGrid)

when isMainModule:
    let inputs = loadExample(currentSourcePath().parentDir())

    let grid = collect:
        for line in inputs:
            line[0].toSeq()

    timeIt "puzzle 1":
        var (total, _) = grid.reduce()
        echo "solution: $#" % [$total]

    echo ""


    total = 0
    timeIt "puzzle 2":
        var result:tuple[total: int, grid: seq[seq[char]]] = (1, grid)
        while result.total > 0:
            result = result.grid.reduce()
            total += result.total
            # echo "new grid $#" % [$result.total]
        echo "solution: $#" % [$total]


