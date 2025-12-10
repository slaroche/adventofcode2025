import commons/utils
import commons/timeit
import os
import strutils
import sequtils
import sugar
import math
import cpuinfo
import malebolgia


const JoltageCount = 12


type
    FChannel[T] = object
        channel: Channel[T]
        done: bool = false

    Bank = object
        value: seq[int]


proc open[T](self: var FChannel[T]; maxItems: int = 0) = self.channel.open(maxItems)
proc close[T](self: var FChannel[T]) = self.channel.close()
proc trySend[T](self: var FChannel[T], msg: T): bool = self.channel.trySend(msg)
proc send[T](self: var FChannel[T], msg: T) = self.channel.send(msg)
proc tryRecv[T](self: var FChannel[T]): tuple[dataAvailable: bool, msg: T] = self.channel.tryRecv()
proc recv[T](self: var FChannel[T]): T = self.channel.recv()


func openBatteries(first, second: char): int = 
    parseInt($first & $second)


func findJoltage(bank: seq[int]): int = 
    result = 0
    var bat: int = bank[result]
    for i in 0..<bank.len:
        if bank[i] > bat:
            result = i
            bat = bank[i]


proc toBank(bankStr: string): Bank = Bank(value: bankStr.toSeq().map(proc (x: char): int = parseInt($x)))
proc open(bank: Bank): int = 
    var 
        joltage: seq[string] = @[]
        index = 0

    while joltage.len < JoltageCount:
        let selectedBank = bank.value[index..bank.value.len - (JoltageCount - joltage.len)] 
        index += findJoltage(selectedBank)
        joltage.add($bank.value[index])
        index += 1
    
    joltage.join("").parseInt()


proc consume(chan: ptr FChannel[Bank]; joltagesChan: ptr Channel[int]) {.gcsafe.} =
    while true:
        let (available, bank) = chan[].tryRecv()
        if not available and chan[].done: break
        elif available: joltagesChan[].send(bank.open())


proc produce(chan: ptr FChannel[Bank]; banks: seq[string]) {.gcsafe.} =
    for bankStr in banks: 
        chan[].send(toBank(bankStr))
    chan[].done = true


if isMainModule:
    # let inputs = loadExample(currentSourcePath().parentDir())
    let inputs = loadInput(currentSourcePath().parentDir())

    let banks = collect:
        for line in inputs:
            line[0]


    timeIt "puzzle 1":
        var joltages: seq[int] = @[]

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


    timeIt "puzzle 2":
        var 
            joltagesChan: Channel[int]
            banksChan = FChannel[Bank]()
            m = createMaster()

        banksChan.open(10)
        joltagesChan.open()
        defer: banksChan.close()
        defer: joltagesChan.close()

        m.awaitAll:
            m.spawn produce(addr banksChan, banks)

            for _ in 0..countProcessors():
                m.spawn consume(addr banksChan, addr joltagesChan)

        var totalJoltages = 0
        for _ in 0..<joltagesChan.peek():
            totalJoltages += joltagesChan.recv()

        echo "solution: $#" % [$totalJoltages]

