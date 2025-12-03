import commons/inpututils
import commons/timeit
import os
import strutils
import sequtils
import sugar
import math


func openBatteries(first, second: char): int = 
    parseInt($first & $second)


func findJoltage(bank: seq[int]): int = 
    result = 0
    var bat: int = bank[result]
    for i in 0..<bank.len:
        if bank[i] > bat:
            result = i
            bat = bank[i]


const JoltageCount = 12


if isMainModule:
    # let inputs = loadExample(currentSourcePath().parentDir())
    let inputs = loadInput(currentSourcePath().parentDir())

    let banks = collect:
        for line in inputs:
            line[0]

    var joltages: seq[int] = @[]

    timeIt "puzzle 1":
        for bank in banks:
            var joltage = 0
            for i in 0..bank.len - 2:
                for j in i + 1..bank.len - 1:
                    joltage = max(
                        joltage, 
                        openBatteries(bank[i], bank[j]),
                    )
            joltages.add(joltage)

        echo "solution: $#" % [$(sum(joltages))]

    echo ""
    joltages = @[]

    timeIt "puzzle 2":
        for bankStr in banks:
            let bank: seq[int] = bankStr.toSeq().map(proc (x: char): int = parseInt($x))
            var 
                joltage: seq[string] = @[]
                index = 0

            while joltage.len < JoltageCount:
                let selectedBank = bank[index..bank.len - (JoltageCount - joltage.len)] 
                index += findJoltage(selectedBank)
                joltage.add($bank[index])
                index += 1
            
            joltages.add(joltage.join("").parseInt())

        echo "solution: $#" % [$(sum(joltages))]
