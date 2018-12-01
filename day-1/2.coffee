{ log, dir, assert } = console


# takes an input string (-1, -2, -3)
# and sums up all the numbers
calibrate = (input)->
  # parse input
  steps = (parseInt(i, 10) for i in input.match /([+-]?\d+)/g)

  # init history
  freq = 0
  history = {"#{freq}": true}

  while true # loop until we find a dupe
    for step in steps
      freq = freq + step
      return freq if history[freq]
      history[freq] = true

###
  Answer
###

log calibrate require './input.coffee'


###
  Tests
###

examples = """
+1, -1 first reaches 0 twice.
+3, +3, +4, -2, -4 first reaches 10 twice.
-6, +3, +8, +5, -6 first reaches 5 twice.
+7, +7, -2, -7, -4 first reaches 14 twice.
"""

for example in examples.split "\n"
  [..., steps, answer] = example.match /^(.*) first reaches (\d+) twice\./
  answer = parseInt answer, 10

  assert answer is calibrate steps
