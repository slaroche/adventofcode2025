import commons/inpututils
import commons/timeit
import os
import strutils
import sugar
import sequtils
import algorithm


when isMainModule:
    # let inputs = loadExample(currentSourcePath().parentDir())
    let inputs = loadInput(currentSourcePath().parentDir())

    var index = 0
    var ingredientIdRanges: seq[tuple[start, to:int]] = collect:
        for line in inputs:
            index += 1
            if line.len == 0: break
            (
                line[0].split('-')[0].parseInt(), 
                line[0].split('-')[1].parseInt(), 
            )

    let ingredientIds: seq[int] = collect:
        for line in inputs[index..^1]:
            line[0].parseInt()  

    timeIt "puzzle 1":
        var totalValidIngredient = 0
        var visitedIngredientIds: seq[int] = @[]

        for ingredientId in ingredientIds:
            for (startId, endId) in ingredientIdRanges:
                if ingredientId in visitedIngredientIds: continue
                if ingredientId in startId..endId:
                    totalValidIngredient += 1
                    visitedIngredientIds.add(ingredientId)

        echo "solution: $#" % [$totalValidIngredient]

    echo ""


    timeIt "puzzle 2":
        var mergedRanges: seq[tuple[start, to: int]] = @[]
        var remainingRanges: seq[tuple[start, to: int]] = ingredientIdRanges.sorted(
            proc (a, b: tuple[start, to: int]): int = cmp(a.start, b.start)
        )

        while remainingRanges.len > 0:
            var (lowerStart, lowerEnd) = remainingRanges[0]
            for (startId, endId) in remainingRanges:
                if startId <= lowerEnd and lowerEnd < endId:
                    lowerEnd = endId
            
            mergedRanges.add((lowerStart, lowerEnd))
            remainingRanges = remainingRanges.filter(
                proc (x: tuple[start, to: int]): bool = x.start > lowerEnd
            )

        totalValidIngredient = 0
        for (startId, endId) in mergedRanges:
            totalValidIngredient += (endId - startId) + 1

        echo "solution: $#" % [$totalValidIngredient]

