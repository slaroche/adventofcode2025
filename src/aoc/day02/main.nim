import commons/inpututils
import os
import strutils
import sugar
import math

# let inputs = loadExample(currentSourcePath().parentDir())
let inputs = loadInput(currentSourcePath().parentDir())

func getIds(rangeItem: string): seq[int] =
    let 
        form = parseInt(rangeItem.split('-')[0])
        to = parseInt(rangeItem.split('-')[1])
    for id in form .. to:
        result.add(id)

func isMirrored(id: string): bool =
    if id.len mod 2 != 0: return false
    id[0..id.len div 2 - 1] == id[id.len div 2..^1]

func sliceOnIndex(str: string, index: int, rest: bool = false): string =
    if rest: str[index..^1]
    else: str[0..index - 1]

func splitGroup(str: string, size: int): seq[string] = 
    var rest: string = str
    while rest.len > 0:
        result.add(sliceOnIndex(rest, size))
        rest = sliceOnIndex(rest, size, rest=true)

func same(parts: seq[string]): bool =
    for i in 1..parts.len - 1:
        if parts[i - 1] != parts[i]: return false
    return true

func toChar(str: string): seq[string] =
    for char in str:
        result.add($char)

func isRepeated(id: string): bool =
    if id.len == 1: return false
    if same(toChar(id)): return true
    if id.len == 3: return false

    var i = 1
    while i + 1 <= id.len div 2:
        i += 1
        if id.len mod i != 0: 
            continue

        let parts = splitGroup(id, size=i)
        if same(parts): return true

    discard


let parts = collect:
    for line in inputs:
        for part in line:
            part.split(',')


var invalidIds: seq[int] = @[]

for currentRange in parts:
    for id in getIds(currentRange):
        if isMirrored($id): invalidIds.add(id)
                
echo "puzzle 1: ", sum(invalidIds)

invalidIds = @[]
for currentRange in parts:
    for id in getIds(currentRange):
        if isRepeated($id): invalidIds.add(id)

echo "puzzle 2: ", sum(invalidIds)
