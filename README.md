# adventofcode2025

## Install deps

```
nimble install -d
```

## Run day

```
nim c --run -d:release -o:bin/run src/aoc/{DAY}/main.nim
```

## Debug

```
nim c --debuginfo --linedir:on --debugger:native -o:bin/debug src/aoc/{DAY}/main.nim
```
