import commons/utils
import commons/timeit
import os
import sugar
import strformat
import strutils
import sequtils
import math
import algorithm
import options

type Point = tuple[x, y, z: int]
type Conn = tuple[dis: int, a, b: Point]

func distance(a, b: Point): int =
    int(sqrt(float((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2)))

func findIndex(clusters: seq[seq[Point]]; junc: Point): Option[int] =
    for index in 0..<clusters.len: 
        if junc in clusters[index]: 
            return index.some()

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
            var indexA = clusters.findIndex(c.a)
            var indexB = clusters.findIndex(c.b)
            if indexA.isNone() and indexB.isNone(): 
                clusters.add(@[c.a, c.b])
            elif indexA.isSome() and indexB.isNone():
                clusters[indexA.get()].add(c.b)
            elif indexA.isNone() and indexB.isSome():
                clusters[indexB.get()].add(c.a)
            elif indexA.get() == indexB.get(): 
                continue
            else:
                for b in clusters[indexB.get()]:
                    clusters[indexA.get()].add(b)
                clusters.delete(indexB.get())

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
