import os
import strutils


proc load(parentDir: string, name: string): seq[seq[string]] = 
  let inputPath = parentDir / name
  let content = readFile(inputPath).strip()
  for line in content.splitLines():
    result.add(line.splitWhitespace())

proc loadInput*(parentDir: string): seq[seq[string]] =  load(parentDir, "input.txt")

proc loadExample*(parentDir: string): seq[seq[string]] = load(parentDir, "example.txt")
