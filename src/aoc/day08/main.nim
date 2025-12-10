import commons/utils
import commons/timeit
import os
import sugar
import strformat
import strutils
import sequtils
import math
import algorithm
import sets

type Point = tuple[x, y, z: int]
type Conn = tuple[dis: int, a, b: Point]

func distance(a, b: Point): int =
    int(sqrt(float((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2)))

when isMainModule:
    # let inputs = loadExample(currentSourcePath().parentDir())
    # const MaxPairs = 10
    let inputs = loadInput(currentSourcePath().parentDir()) 
    const MaxPairs = 1000

    timeIt "puzzle 1":
        let junc: seq[Point] = collect:
            for line in inputs:
                let values = line[0].split(',').map(
                    proc (x: string): int = x.parseInt()
                )
                (values[0], values[1], values[2])
        
        var connections: seq[Conn] = collect:
            for i in 0..<junc.len:
                for j in i+1..<junc.len:
                    (distance(junc[i], junc[j]), junc[i], junc[j])
        
        connections.sort(proc (a, b: Conn): int = cmp(a.dis, b.dis))

        var clusters: seq[seq[Point]] = @[]
        for c in connections[0..<MaxPairs]:
            var indexA = -1
            var indexB = -1
            for index in 0..<clusters.len: 
                if c.a in clusters[index]: 
                    indexA = index
                    break
            for index in 0..<clusters.len: 
                if c.b in clusters[index]:
                    indexB = index
                    break
            if indexA == -1 and indexB == -1: 
                clusters.add(@[c.a, c.b])
            elif indexA == indexB: 
                continue
            elif indexA != -1 and indexB == -1:
                clusters[indexA].add(c.b)
            elif indexA == -1 and indexB != -1:
                clusters[indexB].add(c.a)
            else:
                for b in clusters[indexB]:
                    clusters[indexA].add(b)
                clusters.delete(indexB)

        clusters.sort(proc (a, b: seq[Point]): int = cmp(b.len, a.len))
        # for i in 0..<3:
        #     echo fmt"cluster: {clusters[i].len}"
        var total = 1
        for x in clusters[0..<3]:
            total *= x.len
        echo fmt"clusters: {total}"


    echo ""


    timeIt "puzzle 2":
        total = 0
        echo fmt"solution: {total}"
