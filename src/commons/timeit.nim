import times

template timeIt*(name: string, body: untyped) =
  let startTime = cpuTime()
  echo name, ":"
  body
  echo "took ", cpuTime() - startTime, " seconds"
