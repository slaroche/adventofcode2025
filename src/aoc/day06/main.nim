import commons/utils
import commons/timeit
import os
import strutils
import sugar
import strformat
import math

type Problem = object
  numbers: seq[string]
  operator: string

proc loadMatrix(name: string): seq[string] = 
    let inputPath = currentSourcePath().parentDir() / name
    let content = readFile(inputPath)
    for line in content.splitLines():
        if line.len == 0: continue
        result.add(line)

when isMainModule:
    let inputs = loadExample(currentSourcePath().parentDir())
    # let inputs = loadInput(currentSourcePath().parentDir())

    var mathProblems: seq[seq[string]] = collect:
        for j in 0..<inputs[0].len:
            var problem: seq[string] = @[]
            for i in 0..<inputs.len:
                problem.add(inputs[i][j])
            problem

    timeIt "puzzle 1":
        var total: seq[int] = @[]
        for problem in mathProblems:
            let operator = problem[^1]
            var result = if operator == "+": 0 else: 1
            for num in problem[0..^2]:
                if operator == "+":
                    result += num.parseInt()
                elif operator == "*":
                    result *= num.parseInt()
            total.add(result)
        echo fmt"solution: {sum(total)}"


    echo ""


    timeIt "puzzle 2":
        # let inputList: seq[string] = loadMatrix("example.txt")
        let inputList: seq[string] = "input.txt".loadMatrix()

        var problems: seq[Problem] = @[]
        var operator: string = ""
        var numbers: seq[string] = @[]
        for i in 0..<inputList[0].len:
            var temp: seq[string] = @[]
            for j in 0..<inputList.len:
                temp.add($inputList[j][i])
            var number: string = temp.join("")
            if number.splitWhitespace().len == 0:
                let problem = Problem(numbers: numbers, operator: operator)
                problems.add(problem)
                numbers = @[]
                operator = ""
                continue

            if number[^1] in ['+', '*']:
                operator = $number[^1]
            
            numbers.add(number[0..^2])

        problems.add(Problem(numbers: numbers, operator: operator))

        total= @[]
        for problem in problems:
            var result = if problem.operator == "+": 0 else: 1
            for number in problem.numbers:
                if problem.operator == "+":
                    result += number.strip(chars={' '}).parseInt()
                elif problem.operator == "*":
                    result *= number.strip(chars={' '}).parseInt()
            total.add(result)

        # echo total
        echo "solution: $#" % [$sum(total)]

