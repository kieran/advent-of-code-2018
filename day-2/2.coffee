{ log, dir, assert, time, timeEnd } = console


process = (input='')->
  input = input.split "\n"
  while one = input.shift()
    for line in input
      diffs = diffPositions one, line
      if diffs.length is 1
        return one.substr(0,diffs[0]) + one.substr(diffs[0]+1)


diffPositions = (one, two)->
  ret = []
  for i in [0..(one.length-1)]
    ret.push i unless one.charAt(i) is two.charAt(i)
    return ret if ret.length > 1 # short-cut for max of 2 diffs
  ret


###
  Answer
###

input = require './input.coffee'

time 'runtime'
log process input
timeEnd 'runtime'


###
  Tests
###

input = """
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz
"""

assert 'fgij' is process input
