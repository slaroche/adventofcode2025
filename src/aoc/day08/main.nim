import commons/inpututils
import commons/timeit
import os
import sugar
import strformat
import strutils
import sequtils
import math
import algorithm

func distance(a , b: tuple[x, y, z: int]): int =
    int(sqrt(float((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2)))

when isMainModule:
    # let inputs = loadExample(currentSourcePath().parentDir())
    # const MaxPairs = 10
    let inputs = loadInput(currentSourcePath().parentDir())
    const MaxPairs = 1000

    timeIt "puzzle 1":
        let junc: seq[tuple[x, y, z: int]] = collect:
            for line in inputs:
                let values = line[0].split(',').map(
                    proc (x: string): int = x.parseInt()
                )
                (values[0], values[1], values[2])
        
        type Conn = tuple[dis: int,a, b: tuple[x, y, z: int]]
        var conn: seq[Conn] = collect:
            for i in 0..<junc.len:
                for j in i+1..<junc.len:
                    (distance(junc[i], junc[j]), junc[i], junc[j])
        
        conn.sort(proc (a, b: Conn): int = cmp(a.dis, b.dis))
        conn = conn[0..<MaxPairs]
        
        var clusters: seq[seq[tuple[x, y, z: int]]] = @[]
        for con in conn:
            for i in 0..<clusters.len:
                if con.a in clusters[i] and con.b in clusters[i]:
                    break
                if con.a in clusters[i]:
                    clusters[i].add(con.b)
                    break
                if con.b in clusters[i]:
                    clusters[i].add(con.a)
                    break

            clusters.add(@[con.a, con.b])
        


        let clusterLens = collect:
            for cluster in clusters:
                cluster.len

        let biggestCSize = clusterLens.sorted().reversed()[0..<3]
        echo biggestCSize
        var total = 1
        for size in biggestCSize:
            total *= size
        
        echo fmt"solution: {total}"


    echo ""


    timeIt "puzzle 2":
        total = 0
        echo fmt"solution: {total}"
