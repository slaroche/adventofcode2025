import commons/inpututils
import commons/timeit
import os
import sequtils
import sugar
import strformat


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
        total = 0
        var : seq[seq[char]] = collect:
            for line in inputs:
                line[0].toSeq()
        var maniworlds: seq[seq[seq[char]]] = @[firstWorld]

        var x = 0
        while true:
            var foundStart = false
            for i in 1..<maniworlds[x].len:
                for j in 0..<maniworlds[x][i].len:
                    if not foundStart and maniworlds[x][i - 1][j] == 'S':
                        foundStart = true
                        maniworlds[x][i][j] = '|'
                        maniworlds[x][i - 1][j] = '|'
                    elif not foundStart:
                        continue
                    if maniworlds[x][i][j] == '^' and maniworlds[x][i - 1][j] == '|':
                        var newWorld = maniworlds[x]
                        newWorld[i][j + 1] = 'S'
                        maniworlds.add(newWorld)
                        maniworlds[x][i][j - 1] = '|'
                    elif maniworlds[x][i - 1][j] == '|':
                        maniworlds[x][i][j] = '|'
            # if x == 2:
            #     for line in maniworlds[x]:
            #         echo line
                
            #     echo fmt"currentCount: {currentCount}, maniworlds.len: {maniworlds.len}"
            #     quit 0

            x += 1
            if maniworlds.len == x:
                break
        # var index = 0
        # for world in maniworlds:
        #     echo fmt"world: {index}"
        #     index += 1
        #     for line in world:
        #         echo line
        #     echo ""
        echo fmt"solution: {maniworlds.len}"
