{ log, dir, assert, time, timeEnd } = console

# replacement regex
regex = new RegExp(
  'abcdefghijklmnopqrstuvwxyz'
  .split ''
  .map (a)->
    "#{a}#{a.toUpperCase()}|#{a.toUpperCase()}#{a}"
  .join '|'
)

# reaction generator
react = (polymer)->
  loop
    newPolymer = polymer.replace regex, ''
    break if newPolymer is polymer
    yield newPolymer
    polymer = newPolymer

# fully react the polymer to it's stable state
reduce = (polymer)->
  [..., ret] = (iteration for iteration from react polymer)
  ret


###
  Answer
###

input = require './input.coffee'

time 'runtime'
log reduce(input).length
timeEnd 'runtime'


###
  Tests
###

input = """
dabAcCaCBAcCcaDA
dabAaCBAcCcaDA
dabCBAcCcaDA
dabCBAcaDA
"""

stages = input.split "\n"

# test generator
polymer = react stages[0]
assert stages[1] is polymer.next().value
assert stages[2] is polymer.next().value
assert stages[3] is polymer.next().value
assert true is polymer.next().done

# test reducer
assert 10 is reduce(stages[0]).length
