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

type Junc = tuple[x, y, z: int]
type Conn = tuple[dis: int, a, b: Junc]


func distance(a, b: Junc): int =
    int(sqrt(float((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2)))


func findIndex(clusters: seq[seq[Junc]]; junc: Junc): Option[int] =
    for index in 0..<clusters.len: 
        if junc in clusters[index]: 
            return index.some()

proc partA(inputs: seq[seq[string]]): int =
    # const MaxPairs = 10
    const MaxPairs = 1000

    let juncs: seq[Junc] = collect:
        for line in inputs:
            let values = line[0].split(',').map(
                proc (x: string): int = x.parseInt()
            )
            (values[0], values[1], values[2])
    
    var connections: seq[Conn] = collect:
        for i in 0..<juncs.len:
            for j in i+1..<juncs.len:
                (distance(juncs[i], juncs[j]), juncs[i], juncs[j])
    
    connections.sort(proc (a, b: Conn): int = cmp(a.dis, b.dis))

    var clusters: seq[seq[Junc]] = @[]
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

    clusters.sort(proc (a, b: seq[Junc]): int = cmp(b.len, a.len))
    result = 1
    for x in clusters[0..<3]:
        result *= x.len

proc partB(inputs: seq[seq[string]]): int = 
    var juncs: seq[Junc] = collect:
        for line in inputs:
            let values = line[0].split(',').map(
                proc (x: string): int = x.parseInt()
            )
            (values[0], values[1], values[2])
    
    var connections: seq[Conn] = collect:
        for i in 0..<juncs.len:
            for j in i+1..<juncs.len:
                (distance(juncs[i], juncs[j]), juncs[i], juncs[j])
    
    connections.sort(proc (a, b: Conn): int = cmp(a.dis, b.dis))

    var clusters: seq[seq[Junc]] = @[]
    var index = 0

    var lastConnection = none(Conn)
    while juncs.len > 0 or clusters.len != 1:
        let c = connections[index]
        index += 1

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

        juncs = juncs.filterIt(it != c.a)
        juncs = juncs.filterIt(it != c.b)

        lastConnection = some(c)
    if lastConnection.isSome():
        echo fmt"lastConnection: {lastConnection.get()}"
        echo fmt"clusters: {clusters.len}"
        echo fmt"juncs: {juncs.len}"

        result = lastConnection.get.a.x * lastConnection.get.b.x
    else:
        echo fmt"no last connection"


when isMainModule:
    # let inputs = loadExample(currentSourcePath().parentDir())
    let inputs = loadInput(currentSourcePath().parentDir()) 

    timeIt "puzzle 1":
        echo fmt"solution: {partA(inputs)}"

    echo ""

    timeIt "puzzle 2":
        echo fmt"solution: {partB(inputs)}"
