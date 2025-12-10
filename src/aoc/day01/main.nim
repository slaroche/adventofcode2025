import commons/utils
import os
import strutils

# let inputs = loadExample(currentSourcePath().parentDir())
let inputs = loadInput(currentSourcePath().parentDir())

var pointer: int = 50
var counter: int = 0

for line in inputs:
    for input in line:
        let dir: char = input[0]
        let dis: int = parseInt(input[1..^1]) mod 100

        if dir == 'L': pointer -= dis
        elif dir == 'R': pointer += dis
            
        if pointer < 0: pointer = 100 - abs(pointer)
        elif pointer > 99: pointer = pointer - 100

        if pointer == 0: counter += 1

echo "puzzle 1: ", counter

pointer = 50
counter = 0

for line in inputs:
    for input in line:
        let dir: char = input[0]
        let dis: int = parseInt(input[1..^1])
        if dis > 99: counter += dis div 100

        let before: int = pointer
        if dir == 'L': pointer -= dis mod 100
        elif dir == 'R': pointer += dis mod 100
        
        if pointer < 0: pointer = 100 - abs(pointer)
        elif pointer > 99: pointer = pointer - 100

        if pointer == 0: counter += 1
        elif before != 0:
            if dir == 'L' and pointer > before: counter += 1
            elif dir == 'R' and pointer < before: counter += 1

echo "puzzle 2: ", counter
