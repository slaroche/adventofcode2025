import commons/utils
import commons/timeit
import os
import sugar
import strformat
import strutils
import sequtils


type Tile = object
    x, y: int

type Rec = ref object
    a, b: Tile


func aria(a, b: Tile): int {.inline.} =
    (abs(a.x - b.x) + 1) * (abs(a.y - b.y) + 1)


func aria(rec: Rec): int {.inline.} =
    aria(rec.a, rec.b)

proc isInside(tile: Tile, rec: Rec): bool =
    min(rec.a.x, rec.b.x) <= tile.x and 
    max(rec.a.x, rec.b.x) >= tile.x and 
    min(rec.a.y, rec.b.y) <= tile.y and 
    max(rec.a.y, rec.b.y) >= tile.y


proc includes(rec: Rec, tile: Tile): bool {.inline.} =
    tile in @[rec.a, rec.b, Tile(x: rec.a.x, y: rec.b.y), Tile(x: rec.b.x, y: rec.a.y)]
    

proc partA(inputs: seq[seq[string]]): int =
    var tiles: seq[Tile] = collect:
        for line in inputs:
            let values = line[0].split(',').map(
                proc (x: string): int = x.parseInt()
            )
            Tile(x: values[0], y: values[1])

    for i, a in enumerate tiles:
        for b in tiles[i + 1..^1]:
            result = max(result, aria(a, b))

proc partB(inputs: seq[seq[string]]): int =
    var tiles: seq[Tile] = collect:
        for line in inputs:
            let values = line[0].split(',').map(
                proc (x: string): int = x.parseInt()
            )
            Tile(x: values[0], y: values[1])

    var recs: seq[Rec] = collect:
        for (i, a) in enumerate(tiles):
            for  b in tiles[i + 1..^1]:
                Rec(a: a, b: b)

    recs = recs.filter(proc (r: Rec): bool = 
        for tile in tiles:
            if r.includes(tile):
                continue
            if tile.isInside(r):
                return false
        return true
    )
    return recs.map(proc (r: Rec): int = r.aria).max()


when isMainModule:
    let inputs = loadExample(currentSourcePath().parentDir())
    # let inputs = loadInput(currentSourcePath().parentDir())

    timeIt "puzzle 1":
        echo fmt"solution: {partA(inputs)}"

    echo ""

    timeIt "puzzle 2":
        echo fmt"solution: {partB(inputs)}"
