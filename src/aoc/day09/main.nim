import commons/utils
import commons/timeit
import os
import sugar
import strformat
import strutils
import sequtils
import math
import algorithm


when isMainModule:
    let inputs = loadExample(currentSourcePath().parentDir())
    # let inputs = loadInput(currentSourcePath().parentDir())

    var points: seq[tuple[x, y: int]] = collect:
        for line in inputs:
            let values = line[0].split(',').map(
                proc (x: string): int = x.parseInt()
            )
            (values[0], values[1])

    let height = points.map(proc (x: tuple[x, y: int]): int = x.x).max() + 1 
    let width = points.map(proc (x: tuple[x, y: int]): int = x.y).max() + 1

    timeIt "puzzle 1":
        var total = 0
        for i in 0..<points.len:
            for j in i + 1..<points.len:
                let a = points[i]
                let b = points[j]
                total = max(
                    total,
                    (abs(a.x - b.x) + 1) * (abs(a.y - b.y) + 1),
                )
                
        echo fmt"solution: {total}"



    echo ""

    timeIt "puzzle 2":
        echo fmt"width: {width}, height: {height}"
        var grid: seq[string] = @[]
        for i in 0..<width:
            var line: string = ""
            for j in 0..<height:
                echo fmt"i: {i}, j: {j}"
                if (i, j) in points:
                    line &= "#"
                else:
                    line &= "."
            grid.add(line)
        for line in grid:
            echo line
        echo fmt"solution: {0}"
