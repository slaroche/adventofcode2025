import os
import strutils


proc load(parentDir: string, name: string): seq[seq[string]] = 
  let inputPath = parentDir / name
  let content = readFile(inputPath).strip()
  for line in content.splitLines():
    result.add(line.splitWhitespace())


proc loadInput*(parentDir: string): seq[seq[string]] =  load(parentDir, "input.txt")


proc loadExample*(parentDir: string): seq[seq[string]] = load(parentDir, "example.txt")


iterator enumerate*[T](s: seq[T]): tuple[index: int, item:T] {.inline.} =
  for i in 0..<s.len:
    yield (i, s[i])
