import commons/utils
import commons/timeit
import os
import sugar
import strformat
import math


when isMainModule:
    # let inputs = loadExample(currentSourcePath().parentDir())
    let inputs = loadInput(currentSourcePath().parentDir())

    timeIt "puzzle 1":
        var total = 0

        var manifold = collect:
            for line in inputs:
                line[0]

        for i in 1..<manifold.len:
            for j in 0..<manifold[i].len:
                if manifold[i][j] == '^' and manifold[i - 1][j] == '|':
                    total += 1
                    manifold[i][j - 1] = '|'
                    manifold[i][j + 1] = '|'
                elif manifold[i - 1][j] == 'S' or manifold[i - 1][j] == '|':
                   manifold[i][j] = '|'

        echo fmt"solution: {total}"


    echo ""


    timeIt "puzzle 2":
        var world: seq[seq[int]] = collect:
            for line in inputs:
                var newLine: seq[int] = @[]
                for space in line[0]:
                    if space == 'S':
                        newLine.add(1)
                    elif space == '.':
                        newLine.add(0)
                    else:
                        newLine.add(-1)
                newLine

        for i in 1..<world.len:
            for j in 0..<world[i].len:
                if world[i][j] == -1:
                    var num = world[i - 1][j]
                    var right = world[i][j - 1]
                    var left = world[i][j + 1]
                    world[i][j - 1] = num + right
                    world[i][j + 1] = num + left
                elif world[i - 1][j] > 0:
                    world[i][j] = world[i - 1][j] + world[i][j]

        echo fmt"solution: {sum(world[^1])}"
