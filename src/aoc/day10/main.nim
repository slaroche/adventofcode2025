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


type Button = seq[int]


type Machine = ref object of RootObj
    lights: string
    buttons: seq[Button]
    joltage: string


func newMachine(
    lights: string,
    buttons: seq[string],
    joltage: string,
): Machine =
    result = new Machine
    result.buttons = collect:
        for button in buttons:
            button[1..^2].split(',').map(
                proc (x: string): int = x.parseInt()
            )
    result.lights = lights
    result.joltage = joltage


func distance(a: string): int =
    return a.strip(chars = {'.'}).len


func flip(light: char): char =
    if light == '#': return '.'
    if light == '.': return '#'


func first[T](l: seq[T]): Option[T] =
    for item in l:
        return some(item)
    return none(T)


func press(lights: string, buttons: Button): string =
    result = lights
    for button in buttons:
        result[button] = lights[button].flip


proc totalPress(machine: Machine): int =
    var states: seq[string] = @[machine.lights]
    var done = false
    while not done:
        result += 1

        var newStates: seq[string] = @[]
        for state in states:
            for button in machine.buttons:
                let newState = state.press(button)
                newStates.add(newState)
                if newState.distance == 0:
                    done = true
                    break
            if done:
                break
        if done:
            break
        states = newStates


proc partA(inputs: seq[seq[string]]): int =
    let machines = collect:
        for input in inputs:
            newMachine(input[0][1..^2], input[1..^2], input[^1])

    for machine in machines:
        result += machine.totalPress()

# proc partA(inputs: seq[seq[string]]): int =
#     let machines = collect:
#         for input in inputs:
#             newMachine(input[0][1..^2], input[1..^2], input[^1])

#     for machine in machines:
#         var q = machine.lights
#         var c = 0
#         echo fmt"machine: {machine.repr}"
#         var buttonsPressed: seq[Button] = @[]
#         while q.distance > 0:
#             c += 1
#             if c > 10: 
#                 break

#             var lastButton = machine.buttons.filter(proc (
#                     x: Button): bool = x notin buttonsPressed).first()
#             if lastButton.isNone():
#                 break

#             let og = q
#             var current = q
#             for button in machine.buttons:
#                 if button in buttonsPressed:
#                     continue

#                 if current.distance > q.press(button).distance:
#                     current = q.press(button)
#                     lastButton = some(button)

#             buttonsPressed.add(lastButton.get())
#             q = q.press(lastButton.get())
#             echo fmt"og: {og}, q: {q}, lastButton: {lastButton.get()}"
#         echo fmt"buttonsPressed: {buttonsPressed.len}"
#         quit 0

#     return 0


proc partB(inputs: seq[seq[string]]): int = 0


when isMainModule:
    # let inputs = loadExample(currentSourcePath().parentDir())
    let inputs = loadInput(currentSourcePath().parentDir())

    timeIt "puzzle 1":
        echo fmt"solution: {partA(inputs)}"

    echo ""

    timeIt "puzzle 2":
        echo fmt"solution: {partB(inputs)}"
