{ log, dir, assert, time, timeEnd } = console
parse         = require 'date-fns/parse'
format        = require 'date-fns/format'
subMinutes    = require 'date-fns/sub_minutes'
addMinutes    = require 'date-fns/add_minutes'
isWithinRange = require 'date-fns/is_within_range'
startOfDay    = require 'date-fns/start_of_day'
setMinutes    = require 'date-fns/set_minutes'
_             = require 'underscore'

class Nap
  constructor: (@start, @end)->

  asleepAt: (date)=>
    isWithinRange date, @start, @end

class Shift
  constructor: (@guard_id, @clock_in)->
    @guard_id = parseInt @guard_id
    @naps = []

  startNap: (start)=>
    nap = new Nap start
    @naps.push nap
    nap

  endNap: (end)=>
    [..., nap] = @naps
    nap.end = subMinutes end, 1
    nap

  asleepAt: (date)=>
    for nap in @naps
      return true if nap.asleepAt date

  minutesAsleep: ->
    start = @midnight()
    num = 0
    for min in [0...60]
      num++ if @asleepAt addMinutes start, min
    num

  midnight: =>
    setMinutes @naps[0].start, 0

  print: =>
    # 11-01  #10  .....####################.....#########################.....

    # midnight on the day of the first nap
    # (sometimes guards clock-in early)
    start = @midnight()

    # log addMinutes start, min for min in [0...60]
    ret = "#{format start, 'MM-DD'}  ##{@guard_id}  "
    for min in [0...60]
      char = if @asleepAt addMinutes(start, min) then '#' else '.'
      ret = "#{ret}#{char}"
    ret

class Calendar
  constructor: ->
    @shifts = []

  parse: (input)=>
    input = input.split "\n"
    input.sort()

    shift = null

    for line in input

      # [1518-11-01 00:00] Guard #10 begins shift
      # [1518-11-01 00:05] falls asleep
      # [1518-11-01 00:25] wakes up
      [..., date, msg] = line.match /^\[1518-(.{11})\]\s(.*)$/
      date = parse "2018-#{date}" # force Zulu for simplicity?

      if msg is 'falls asleep'
        shift.startNap date
      else if msg is 'wakes up'
        shift.endNap date
      else
        [..., guard] = msg.match /Guard #(\d+) begins shift/
        shift = @addShift guard, date

  addShift: (guard, date)=>
    shift = new Shift guard, date
    @shifts.push shift
    shift

  print: ->
    ret = []
    ret.push "Date   ID   Minute"
    # minutes (10's)
    ret.push "            " + (Math.floor min / 10 for min in [0...60]).join ''
    # minutes (1's)
    ret.push "            " + (min % 10 for min in [0...60]).join ''
    ret.push shift.print() for shift in @shifts
    ret.join "\n"

  sleepiest_guard: =>
    scores = {}
    for shift in @shifts when shift.naps.length
      scores[shift.guard_id] ||= 0
      scores[shift.guard_id] += shift.minutesAsleep()

    max = Math.max Object.values(scores)...

    for guard_id, mins of scores
      return parseInt guard_id if mins is max


  sleepiest_minute: (guard)=>
    guard ||= @sleepiest_guard()

    mins = {}

    for shift in @shifts when shift.naps.length and shift.guard_id is guard
      midnight = shift.midnight()
      for min in [0...60]
        mins[min] ||= 0
        mins[min]++ if shift.asleepAt addMinutes midnight, min

    max = Math.max Object.values(mins)...

    for min, num_asleep of mins
      return parseInt min if num_asleep is max


###
  Answer
###

input = require './input.coffee'

cal = new Calendar
cal.parse input
time 'runtime'
log cal.sleepiest_guard() * cal.sleepiest_minute()
timeEnd 'runtime'


###
  Tests
###

input = """
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
"""

cal = new Calendar
cal.parse input
# log cal.print()

expected_cal = """
Date   ID   Minute
            000000000011111111112222222222333333333344444444445555555555
            012345678901234567890123456789012345678901234567890123456789
11-01  #10  .....####################.....#########################.....
11-02  #99  ........................................##########..........
11-03  #10  ........................#####...............................
11-04  #99  ....................................##########..............
11-05  #99  .............................................##########.....
"""

assert expected_cal is cal.print()
assert 10 is cal.sleepiest_guard()
assert 24 is cal.sleepiest_minute()
assert 240 is cal.sleepiest_guard() * cal.sleepiest_minute()
