{ log, dir, assert, time, timeEnd } = console

alphabet = 'abcdefghijklmnopqrstuvwxyz'

# replacement regex
regex = new RegExp(
  alphabet
  .split ''
  .map (a)->
    "#{a}#{a.toUpperCase()}|#{a.toUpperCase()}#{a}"
  .join '|'
, 'g' # speed up since we don't care about every intermediate state
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

# retuewns
without = (polymer, letter)->
  polymer.replace new RegExp(letter, 'ig'), ''

smallest_mutation = (polymer)->
  shortest = polymer
  for letter in alphabet.split ''
    result = reduce without polymer, letter
    shortest = result if result.length < shortest.length
  shortest


###
  Answer
###

input = require './input.coffee'

time 'runtime'
log smallest_mutation(input).length
timeEnd 'runtime'


###
  Tests
###

input = """
dabAcCaCBAcCcaDA
"""

assert 'dabAaBAaDA' is without input, 'c'
assert 4 is smallest_mutation(input).length
