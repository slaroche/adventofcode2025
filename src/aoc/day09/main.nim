import commons/utils
import commons/timeit
import os
import sugar
import strformat
import strutils
import sequtils
import math
import algorithm


proc partA(inputs: seq[seq[string]]): int =
    var points: seq[tuple[x, y: int]] = collect:
        for line in inputs:
            let values = line[0].split(',').map(
                proc (x: string): int = x.parseInt()
            )
            (values[0], values[1])

    let height = points.map(proc (x: tuple[x, y: int]): int = x.x).max() + 1 
    let width = points.map(proc (x: tuple[x, y: int]): int = x.y).max() + 1
    for i in 0..<points.len:
        for j in i + 1..<points.len:
            let a = points[i]
            let b = points[j]
            result = max(
                result,
                (abs(a.x - b.x) + 1) * (abs(a.y - b.y) + 1),
            )

proc partB(inputs: seq[seq[string]]): int = 0

when isMainModule:
    let inputs = loadExample(currentSourcePath().parentDir())
    # let inputs = loadInput(currentSourcePath().parentDir())

    timeIt "puzzle 1":
        echo fmt"solution: {partA(inputs)}"

    echo ""

    timeIt "puzzle 2":
        echo fmt"solution: {partB(inputs)}"
