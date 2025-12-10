import commons/utils
import commons/timeit
import os
import strutils
import sequtils
import sugar
import math
import strformat
import times


func getIds(rangeItem: string): seq[int] =
    let 
        form = parseInt(rangeItem.split('-')[0])
        to = parseInt(rangeItem.split('-')[1])
    for id in form .. to:
        result.add(id)

func isMirrored(id: string): bool =
    if id.len mod 2 != 0: return false
    id[0..id.len div 2 - 1] == id[id.len div 2..^1]

func splitGroup(str: string, size: int): seq[string] = 
    var rest: string = str
    while rest.len > 0:
        result.add(rest[0..<size])
        rest = rest[size..^1]

func same[T: string | char](parts: seq[T]): bool =
    for i in 1..parts.len - 1:
        if parts[i - 1] != parts[i]: return false
    true

func isRepeated(id: string): bool =
    if id.len == 1: return false
    if same(id.toSeq()): return true
    if id.len == 3: return false

    var i = 1
    while i + 1 <= id.len div 2:
        i += 1
        if id.len mod i != 0: 
            continue

        let parts = splitGroup(id, size=i)
        if same(parts): return true

    false


if isMainModule:
    # let inputs = loadExample(currentSourcePath().parentDir())
    let inputs = loadInput(currentSourcePath().parentDir())

    let parts = collect:
        for line in inputs:
            for part in line:
                part.split(',')

    var invalidIds: seq[int] = @[]

    timeIt "puzzle 1":
        for currentRange in parts:
            for id in currentRange.getIds():
                if isMirrored($id): invalidIds.add(id)
                    
        echo fmt"solution: {sum(invalidIds)}"

    invalidIds = @[]

    timeIt "puzzle 2":
        for currentRange in parts:
            for id in currentRange.getIds():
                if isRepeated($id): invalidIds.add(id)

        echo fmt"solution: {sum(invalidIds)}"
