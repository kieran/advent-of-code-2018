{ log, dir, assert } = console


# takes an input string (-1, -2, -3)
# and sums up all the numbers
calibrate = (input)->
  # parse input
  steps = (parseInt(i, 10) for i in input.match /([+-]?\d+)/g)
  # process steps
  steps.reduce (m,v)-> m + v


###
  Answer
###

log calibrate require './input.coffee'


###
  Tests
###

examples = """
+1, -2, +3, +1 results in 3
+1, +1, +1 results in  3
+1, +1, -2 results in  0
-1, -2, -3 results in -6
"""

for example in examples.split "\n"
  # setup
  [steps, answer] = example.split ' results in '
  answer = parseInt answer, 10
  assert answer is calibrate steps
