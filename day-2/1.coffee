{ log, dir, assert, time, timeEnd } = console


checksum = (input='')->
  twos = 0
  threes = 0
  for line in input.split "\n"
    vals = fingerprint line
    twos++ if 2 in vals
    threes++ if 3 in vals

  twos * threes

fingerprint = (input='')->
  ret = {}
  for char in input.split ''
    ret[char] ||= 0
    ret[char]++
  Object.values ret


###
  Answer
###

# time 'checksum'
log checksum require './input.coffee'
# timeEnd 'checksum'


###
  Tests
###

input = """
abcdef
bababc
abbcde
abcccd
aabcdd
abcdee
ababab
"""

assert 12 is checksum input
