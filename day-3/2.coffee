{ log, dir, assert, time, timeEnd } = console

class Fabric
  constructor: (@width=1000, @height=1000)->
    @intact = new Set
    @grid = new Array
    for i in [0...@height]
      @grid[i] = []
      for j in [0...@width]
        @grid[i][j] = '.'
    @

  plot: (input='')=>
    [..., id, left, top, width, height] = input
    # parse input format with patern
    .match /#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)/
    # cast all values as ints
    .map (x)-> parseInt x

    # add to set of intact pieces
    @intact.add id

    for i in [top...(top+height)]
      @claim id, i, j for j in [left...(left+width)]

  claim: (id, i, j)=>
    if @grid[i][j] is '.'
      # mark with id
      @grid[i][j] = id
    else
      # remove both overlapping pieces
      @intact.delete @grid[i][j]
      @intact.delete id
      # mark as cut
      @grid[i][j] = 'X'

  draw: =>
    @grid.map( (row)-> row.join '' ).join "\n"

  overlaps: =>
    ret = 0
    for i in [0...@height]
      for j in [0...@width]
        ret++ if @grid[i][j] is 'X'
    ret

  viable: =>
    Array.from @intact


###
  Answer
###

input = require './input.coffee'

time 'runtime'
fabric = new Fabric 1000, 1000
fabric.plot line for line in input.split "\n"
log fabric.viable()[0]
timeEnd 'runtime'


###
  Tests
###

input = """
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
"""

fabric = new Fabric 8, 8
fabric.plot line for line in input.split "\n"

expected_grid = """
........
...2222.
...2222.
.11XX22.
.11XX22.
.111133.
.111133.
........
"""

assert expected_grid is fabric.draw()
assert 4 is fabric.overlaps()
assert 3 is fabric.viable()[0]
