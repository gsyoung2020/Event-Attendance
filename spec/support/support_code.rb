# frozen_string_literal: true

# support file for storing IceCube specs for future use in testing

# module IceCube
#   describe IceCube::Schedule do
#     it 'should be able to tell us when there is at least one occurrence between two dates' do
#       start_time = WEDNESDAY
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_rule IceCube::Rule.weekly.day(:friday)
#       expect(true).to eq(schedule.occurs_between?(start_time, start_time + IceCube::ONE_DAY * 3))
#     end

#     it 'should be able to tell us when there is no occurrence between two dates' do
#       start_time = WEDNESDAY
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_rule IceCube::Rule.weekly.day(:friday)
#       expect(false).to eq(schedule.occurs_between?(start_time, start_time + IceCube::ONE_DAY))
#     end

#     it 'should be able to get back rtimes from a schedule' do
#       schedule = IceCube::Schedule.new DAY
#       schedule.add_recurrence_time DAY
#       schedule.add_recurrence_time(DAY + 2)
#       expect(schedule.rtimes).to eq([DAY, DAY + 2])
#     end

#     it 'should be able to get back exception times from a schedule' do
#       schedule = IceCube::Schedule.new DAY
#       schedule.add_exception_time DAY
#       schedule.add_exception_time(DAY + 2)
#       expect(schedule.extimes).to eq([DAY, DAY + 2])
#     end

#     it 'should allow calling of .first on a schedule with no arguments' do
#       start_time = Time.now
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_time start_time
#       expect(schedule.first).to eq(start_time)
#     end

#     it 'should be able to ignore nil dates that are inserted as part of a collection to add_recurrence_time' do
#       start_time = Time.now
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_time start_time
#       schedule.add_recurrence_time start_time + IceCube::ONE_DAY
#       schedule.add_recurrence_time nil
#       expect(schedule.all_occurrences).to eq([start_time, start_time + IceCube::ONE_DAY])
#     end

#     it 'should be able to use all_occurrences with no rules' do
#       start_time = Time.now
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_time start_time
#       expect do
#         expect(schedule.all_occurrences).to eq([start_time])
#       end.not_to raise_error
#     end

#     it 'should use occurs_at? when calling occurring_at? with no duration' do
#       schedule = IceCube::Schedule.new
#       expect(schedule).to receive(:occurs_at?)
#       schedule.occurring_at?(Time.now)
#     end

#     it 'should be able to specify a duration on a schedule use occurring_at? on the schedule
#                         to find out if a given time is included' do
#       start_time = Time.local 2010, 5, 6, 10, 0, 0
#       schedule = IceCube::Schedule.new(start_time, duration: 3600)
#       schedule.add_recurrence_rule IceCube::Rule.daily
#       expect(schedule.occurring_at?(Time.local(2010, 5, 6, 10, 30, 0))).to be_truthy # true
#     end

#     it 'should be able to specify a duration on a schedule and use occurring_at? on that schedule
#                         to make sure a time is not included' do
#       start_time = Time.local 2010, 5, 6, 10, 0, 0
#       schedule = IceCube::Schedule.new(start_time, duration: 3600)
#       schedule.add_recurrence_rule IceCube::Rule.daily
#       expect(schedule.occurring_at?(Time.local(2010, 5, 6, 9, 59, 0))).to be_falsey
#       expect(schedule.occurring_at?(Time.local(2010, 5, 6, 11, 0, 0))).to be_falsey
#     end

#     it 'should be able to specify a duration on a schedule and use occurring_at? on that schedule
#                         to make sure the outer bounds are included' do
#       start_time = Time.local 2010, 5, 6, 10, 0, 0
#       schedule = IceCube::Schedule.new(start_time, duration: 3600)
#       schedule.add_recurrence_rule IceCube::Rule.daily
#       expect(schedule.occurring_at?(Time.local(2010, 5, 6, 10, 0, 0))).to be_truthy
#       expect(schedule.occurring_at?(Time.local(2010, 5, 6, 10, 59, 59))).to be_truthy
#     end

#     it 'should be able to explicity remove a certain minute from a duration' do
#       start_time = Time.local 2010, 5, 6, 10, 0, 0
#       schedule = IceCube::Schedule.new(start_time, duration: 3600)
#       schedule.add_recurrence_rule IceCube::Rule.daily
#       schedule.add_exception_time Time.local(2010, 5, 6, 10, 21, 30)
#       expect(schedule.occurring_at?(Time.local(2010, 5, 6, 10, 21, 29))).to be_truthy
#       expect(schedule.occurring_at?(Time.local(2010, 5, 6, 10, 21, 30))).to be_falsey
#       expect(schedule.occurring_at?(Time.local(2010, 5, 6, 10, 21, 31))).to be_truthy
#     end

#     it 'should be able to specify an end time for the schedule and only get those on .first' do
#       start_time = DAY
#       # ensure proper response without the end time
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_rule IceCube::Rule.daily
#       expect(schedule.first(5)).to eq([DAY, DAY + 1 * IceCube::ONE_DAY, DAY + 2 * IceCube::ONE_DAY, DAY + 3 * IceCube::ONE_DAY,
#                                        DAY + 4 * IceCube::ONE_DAY])
#       # and then ensure that with the end time it stops it at the right day
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_rule IceCube::Rule.daily.until(DAY + IceCube::ONE_DAY * 2 + 1)
#       expect(schedule.first(5)).to eq([DAY, DAY + 1 * IceCube::ONE_DAY, DAY + 2 * IceCube::ONE_DAY])
#     end

#     it 'should be able to specify an end date and go to/from yaml' do
#       start_time = DAY
#       end_time = DAY + IceCube::ONE_DAY * 2
#       schedule = IceCube::Schedule.new(start_time, end_time: end_time)
#       schedule.add_recurrence_rule IceCube::Rule.daily
#       schedule2 = IceCube::Schedule.from_yaml schedule.to_yaml
#       expect(schedule2.end_time).to eq(end_time)
#     end

#     it 'should be able to specify an end date for the schedule and only get those on .occurrences_between' do
#       start_time = DAY
#       end_time = DAY + IceCube::ONE_DAY * 2
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_rule IceCube::Rule.daily.until(end_time)
#       expectation = [DAY, DAY + IceCube::ONE_DAY, DAY + 2 * IceCube::ONE_DAY]
#       expect(schedule.occurrences_between(start_time - IceCube::ONE_DAY,
#                                           start_time + 4 * IceCube::ONE_DAY)).to eq(expectation)
#     end

#     it 'should be able to specify an end date for the schedule and only get those on .occurrences' do
#       start_time = DAY
#       end_time = DAY + IceCube::ONE_DAY * 2
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_rule IceCube::Rule.daily.until(end_time)
#       expectation = [DAY, DAY + IceCube::ONE_DAY, DAY + 2 * IceCube::ONE_DAY]
#       expect(schedule.occurrences(start_time + 4 * IceCube::ONE_DAY)).to eq(expectation)
#     end

#     it 'should be able to work with an end date and .occurs_at' do
#       start_time = DAY
#       end_time = DAY + IceCube::ONE_DAY * 2
#       schedule = IceCube::Schedule.new(start_time)
#       schedule.add_recurrence_rule IceCube::Rule.daily.until(end_time)
#       expect(schedule.occurs_at?(DAY + 4 * IceCube::ONE_DAY)).to be_falsey # out of range
#     end

#     it 'should be able to work with an end date and .occurring_at' do
#       start_time = DAY
#       end_time = DAY + IceCube::ONE_DAY * 2
#       schedule = IceCube::Schedule.new(start_time, duration: 20)
#       schedule.add_recurrence_rule IceCube::Rule.daily.until(end_time)
#       expect(schedule.occurring_at?((DAY + 2 * IceCube::ONE_DAY + 10))).to be_truthy # in range
#       expect(schedule.occurring_at?((DAY + 4 * IceCube::ONE_DAY + 10))).to be_falsey # out of range
#     end

#     it 'should be able to know when to stop with an end date and a rule that misses a few times' do
#       schedule = IceCube::Schedule.new(Time.local(2010, 2, 29))
#       schedule.add_recurrence_rule IceCube::Rule.yearly.until(Time.local(2010, 10, 30))
#       expect(schedule.first(10)).to eq([Time.local(2010, 2, 29)])
#     end
#   end

#   describe DailyRule do
#     describe 'in Vancouver time', system_time_zone: 'America/Vancouver' do
#       it 'should include nearest time in DST start hour' do
#         schedule = Schedule.new(Time.local(2013, 3, 9, 2, 30, 0))
#         schedule.add_recurrence_rule Rule.daily
#         expect(schedule.first(3)).to eq([
#                                           Time.local(2013, 3, 9, 2, 30, 0), # -0800
#                                           Time.local(2013, 3, 10, 3, 30, 0), # -0700
#                                           Time.local(2013, 3, 11, 2, 30, 0)  # -0700
#                                         ])
#       end

#       it 'should not skip times in DST end hour' do
#         schedule = Schedule.new(Time.local(2013, 11, 2, 2, 30, 0))
#         schedule.add_recurrence_rule Rule.daily
#         expect(schedule.first(3)).to eq([
#                                           Time.local(2013, 11, 2, 2, 30, 0), # -0700
#                                           Time.local(2013, 11, 3, 2, 30, 0), # -0800
#                                           Time.local(2013, 11, 4, 2, 30, 0)  # -0800
#                                         ])
#       end

#       it 'should include nearest time to DST start when locking hour_of_day' do
#         schedule = Schedule.new(Time.local(2013, 3, 9, 2, 0, 0))
#         schedule.add_recurrence_rule Rule.daily.hour_of_day(2)
#         expect(schedule.first(3)).to eq([
#                                           Time.local(2013, 3, 9, 2, 0, 0), # -0800
#                                           Time.local(2013, 3, 10, 3, 0, 0), # -0700
#                                           Time.local(2013, 3, 11, 2, 0, 0)  # -0700
#                                         ])
#       end
#     end

#     it 'should update previous interval' do
#       t0 = Time.now
#       rule = Rule.daily(7)
#       rule.interval(5)
#       expect(rule.next_time(t0 + 1, t0, nil)).to eq(t0 + 5 * ONE_DAY)
#     end

#     it 'should produce the correct days for @interval = 1' do
#       schedule = Schedule.new(t0 = Time.now)
#       schedule.add_recurrence_rule Rule.daily
#       # check assumption
#       times = schedule.occurrences(t0 + 2 * ONE_DAY)
#       expect(times.size).to eq(3)
#       expect(times).to eq([t0, t0 + ONE_DAY, t0 + 2 * ONE_DAY])
#     end

#     it 'should produce the correct days for @interval = 2' do
#       schedule = Schedule.new(t0 = Time.now)
#       schedule.add_recurrence_rule Rule.daily(2)
#       # check assumption (3) -- (1) 2 (3) 4 (5) 6
#       times = schedule.occurrences(t0 + 5 * ONE_DAY)
#       expect(times.size).to eq(3)
#       expect(times).to eq([t0, t0 + 2 * ONE_DAY, t0 + 4 * ONE_DAY])
#     end

#     it 'should produce the correct days for @interval = 2 when crossing into a new year' do
#       schedule = Schedule.new(t0 = Time.utc(2011, 12, 29))
#       schedule.add_recurrence_rule Rule.daily(2)
#       # check assumption (3) -- (1) 2 (3) 4 (5) 6
#       times = schedule.occurrences(t0 + 5 * ONE_DAY)
#       expect(times.size).to eq(3)
#       expect(times).to eq([t0, t0 + 2 * ONE_DAY, t0 + 4 * ONE_DAY])
#     end

#     it 'should produce the correct days for interval of 4 day with hour and minute of day set' do
#       schedule = Schedule.new(t0 = Time.local(2010, 3, 1))
#       schedule.add_recurrence_rule Rule.daily(4).hour_of_day(5).minute_of_hour(45)
#       # check assumption 2 -- 1 (2) (3) (4) 5 (6)
#       times = schedule.occurrences(t0 + 5 * ONE_DAY)
#       expect(times).to eq([
#                             t0 + 5 * ONE_HOUR + 45 * ONE_MINUTE,
#                             t0 + 4 * ONE_DAY + 5 * ONE_HOUR + 45 * ONE_MINUTE
#                           ])
#     end

#     describe 'day validation' do
#       it 'allows multiples of 7' do
#         expect { IceCube::Rule.daily(21).day(2, 4) }.to_not raise_error
#       end

#       it 'raises errors for misaligned interval and day (wday) values' do
#         expect do
#           IceCube::Rule.daily(2).day(2, 4)
#         end.to raise_error(ArgumentError, 'day can only be used with multiples of interval(7)')
#       end

#       it 'raises errors for misaligned hour_of_day values when changing interval' do
#         expect do
#           IceCube::Rule.daily.day(3, 6).interval(5)
#         end.to raise_error(ArgumentError, 'day can only be used with multiples of interval(7)')
#       end
#     end

#     describe 'day_of_month validation' do
#       it 'raises errors for misaligned interval and day_of_month values' do
#         expect do
#           IceCube::Rule.daily(2).day_of_month(2, 4)
#         end.to raise_error(ArgumentError, 'day_of_month can only be used with interval(1)')
#       end

#       it 'raises errors for misaligned day_of_month values when changing interval' do
#         expect do
#           IceCube::Rule.daily.day_of_month(3, 6).interval(5)
#         end.to raise_error(ArgumentError, 'day_of_month can only be used with interval(1)')
#       end
#     end
#   end

#   describe WeeklyRule, 'interval validation' do
#     it 'converts a string integer to an actual int when using the interval method' do
#       rule = Rule.weekly.interval('2')
#       expect(rule.validations_for(:interval).first.interval).to eq(2)
#     end

#     it 'converts a string integer to an actual int when using the initializer' do
#       rule = Rule.weekly('3')
#       expect(rule.validations_for(:interval).first.interval).to eq(3)
#     end

#     it 'raises an argument error when a bad value is passed' do
#       expect do
#         Rule.weekly('invalid')
#       end.to raise_error(ArgumentError, "'invalid' is not a valid input for interval. Please pass a postive integer.")
#     end

#     it 'raises an argument error when a bad value is passed using the interval method' do
#       expect do
#         Rule.weekly.interval('invalid')
#       end.to raise_error(ArgumentError, "'invalid' is not a valid input for interval. Please pass a postive integer.")
#     end
#   end

#   describe WeeklyRule do
#     context 'in Vancouver time', system_time_zone: 'America/Vancouver' do
#       it 'should include nearest time in DST start hour' do
#         schedule = Schedule.new(Time.local(2013, 3, 3, 2, 30, 0))
#         schedule.add_recurrence_rule Rule.weekly
#         expect(schedule.first(3)).to eq([
#                                           Time.local(2013, 3, 3, 2, 30, 0), # -0800
#                                           Time.local(2013, 3, 10, 3, 30, 0), # -0700
#                                           Time.local(2013, 3, 17, 2, 30, 0)  # -0700
#                                         ])
#       end

#       it 'should not skip times in DST end hour' do
#         schedule = Schedule.new(Time.local(2013, 10, 27, 2, 30, 0))
#         schedule.add_recurrence_rule Rule.weekly
#         expect(schedule.first(3)).to eq([
#                                           Time.local(2013, 10, 27, 2, 30, 0), # -0700
#                                           Time.local(2013, 11, 3, 2, 30, 0), # -0700
#                                           Time.local(2013, 11, 10, 2, 30, 0) # -0800
#                                         ])
#       end
#     end

#     it 'should update previous interval' do
#       t0 = Time.new(2013, 1, 1)
#       rule = Rule.weekly(7)
#       rule.interval(2)
#       expect(rule.next_time(t0 + 1, t0, nil)).to eq(t0 + 2 * ONE_WEEK)
#     end

#     it 'should produce the correct number of days for @interval = 1 with no weekdays specified' do
#       schedule = Schedule.new(t0 = Time.now)
#       schedule.add_recurrence_rule Rule.weekly
#       # check assumption (2 weeks in the future) (1) (2) (3) (4) (5)
#       times = schedule.occurrences(t0 + (7 * 3 + 1) * ONE_DAY)
#       expect(times.size).to eq(4)
#     end

#     it 'should produce the correct number of days for @interval = 1 with only weekends' do
#       schedule = Schedule.new(t0 = WEDNESDAY)
#       schedule.add_recurrence_rule Rule.weekly.day(:saturday, :sunday)
#       # check assumption
#       expect(schedule.occurrences(t0 + 4 * ONE_WEEK).size).to eq(8)
#     end

#     it 'should set days from symbol args' do
#       schedule = Schedule.new(WEDNESDAY)
#       schedule.add_recurrence_rule Rule.weekly.day(:monday, :wednesday)
#       expect(schedule.rrules.first.validations_for(:day).map(&:day)).to eq([1, 3])
#     end

#     it 'should set days from array of symbols' do
#       schedule = Schedule.new(WEDNESDAY)
#       schedule.add_recurrence_rule Rule.weekly.day(%i[monday wednesday])
#       expect(schedule.rrules.first.validations_for(:day).map(&:day)).to eq([1, 3])
#     end

#     it 'should set days from integer args' do
#       schedule = Schedule.new(WEDNESDAY)
#       schedule.add_recurrence_rule Rule.weekly.day(1, 3)
#       expect(schedule.rrules.first.validations_for(:day).map(&:day)).to eq([1, 3])
#     end

#     it 'should set days from array of integers' do
#       schedule = Schedule.new(WEDNESDAY)
#       schedule.add_recurrence_rule Rule.weekly.day([1, 3])
#       expect(schedule.rrules.first.validations_for(:day).map(&:day)).to eq([1, 3])
#     end

#     it 'should raise an error on invalid input' do
#       schedule = Schedule.new(WEDNESDAY)
#       expect { schedule.add_recurrence_rule Rule.weekly.day(%w[1 3]) }.to raise_error(ArgumentError)
#     end

#     it 'should ignore weekday validation when no days are specified' do
#       schedule = Schedule.new(t0 = WEDNESDAY)
#       schedule.add_recurrence_rule Rule.weekly(2).day([])

#       times = schedule.occurrences(t0 + 3 * ONE_WEEK)
#       expect(times).to eq [t0, t0 + 2 * ONE_WEEK]
#     end

#     it 'should produce the correct number of days for @interval = 2 with only one day per week' do
#       schedule = Schedule.new(t0 = WEDNESDAY)
#       schedule.add_recurrence_rule Rule.weekly(2).day(:wednesday)
#       # check assumption
#       times = schedule.occurrences(t0 + 3 * ONE_WEEK)
#       expect(times).to eq([t0, t0 + 2 * ONE_WEEK])
#     end

#     it 'should produce the correct days for @interval = 2, regardless of the start week' do
#       schedule = Schedule.new(t0 = WEDNESDAY + ONE_WEEK)
#       schedule.add_recurrence_rule Rule.weekly(2).day(:wednesday)
#       # check assumption
#       times = schedule.occurrences(t0 + 3 * ONE_WEEK)
#       expect(times).to eq([t0, t0 + 2 * ONE_WEEK])
#     end

#     it 'should occur every 2nd tuesday of a month' do
#       schedule = Schedule.new(Time.now)
#       schedule.add_recurrence_rule Rule.monthly.hour_of_day(11).day_of_week(tuesday: [2])
#       schedule.first(48).each do |d|
#         expect(d.hour).to eq(11)
#         expect(d.wday).to eq(2)
#       end
#     end

#     it 'should be able to start on sunday but repeat on wednesdays' do
#       schedule = Schedule.new(Time.local(2010, 8, 1))
#       schedule.add_recurrence_rule Rule.weekly.day(:monday)
#       expect(schedule.first(3)).to eq([
#                                         Time.local(2010, 8, 2),
#                                         Time.local(2010, 8, 9),
#                                         Time.local(2010, 8, 16)
#                                       ])
#     end

#     it 'should start weekly rules on monday when monday is the week start' do
#       schedule = Schedule.new(Time.local(2012, 2, 7))
#       schedule.add_recurrence_rule Rule.weekly(2, :monday).day(:tuesday, :sunday)
#       expect(schedule.first(3)).to eq([
#                                         Time.local(2012, 2, 7),
#                                         Time.local(2012, 2, 12),
#                                         Time.local(2012, 2, 21)
#                                       ])
#     end

#     it 'should start weekly rules on sunday by default' do
#       schedule = Schedule.new(Time.local(2012, 2, 7))
#       schedule.add_recurrence_rule Rule.weekly(2).day(:tuesday, :sunday)
#       expect(schedule.first(3)).to eq([
#                                         Time.local(2012, 2, 7),
#                                         Time.local(2012, 2, 19),
#                                         Time.local(2012, 2, 21)
#                                       ])
#     end

#     it 'should find the next date on a biweekly sunday searching from a few days before the date' do
#       t0 = Time.utc(2017, 1, 15, 9, 0, 0)
#       t1 = Time.utc(2017, 1, 24)
#       t2 = t0 + (2 * ONE_WEEK)
#       schedule = Schedule.new(t0, duration: IceCube::ONE_HOUR)
#       schedule.add_recurrence_rule Rule.weekly(2, :sunday).day(:sunday)
#       t3 = schedule.next_occurrence(t1, spans: true)
#       expect(t3).to eq(t2)
#     end

#     it 'finds correct next_occurrence for biweekly rules realigned from beginning of start week' do
#       schedule = IceCube::Schedule.new(Time.utc(2016, 3, 3))
#       schedule.add_recurrence_rule IceCube::Rule.weekly(2).day(:sunday)

#       result = schedule.next_occurrence(Time.utc(2016, 3, 3))
#       expect(result).to eq Time.utc(2016, 3, 13)
#     end

#     it 'finds correct next_occurrence for biweekly rules realigned from skipped week' do
#       schedule = IceCube::Schedule.new(Time.utc(2017, 1, 2))
#       schedule.add_recurrence_rule IceCube::Rule.weekly(2).day(:monday, :tuesday)

#       result = schedule.next_occurrence(Time.utc(2017, 1, 9))
#       expect(result).to eq Time.utc(2017, 1, 16)
#     end

#     it 'finds correct previous_occurrence for biweekly rule realigned from skipped week' do
#       schedule = IceCube::Schedule.new(Time.utc(2017, 1, 2))
#       schedule.add_recurrence_rule IceCube::Rule.weekly(2).day(:monday, :tuesday)

#       result = schedule.previous_occurrence(Time.utc(2017, 1, 9))
#       expect(result).to eq Time.utc(2017, 1, 3)
#     end

#     it 'should validate week_start input' do
#       expect { Rule.weekly(2, :someday) }.to raise_error(ArgumentError)
#     end

#     it 'should produce correct days for bi-weekly interval, starting on a non-sunday' do
#       schedule = IceCube::Schedule.new(Time.local(2015, 3, 3))
#       schedule.add_recurrence_rule IceCube::Rule.weekly(2, :monday).day(:tuesday)
#       range_start = Time.local(2015, 3, 15)
#       times = schedule.occurrences_between(range_start, range_start + IceCube::ONE_WEEK)
#       expect(times.first).to eq Time.local(2015, 3, 17)
#     end

#     it 'should produce correct days for monday-based bi-weekly interval, starting on a sunday' do
#       schedule = IceCube::Schedule.new(Time.local(2015, 3, 1))
#       schedule.add_recurrence_rule IceCube::Rule.weekly(2, :monday).day(:sunday)
#       range_start = Time.local(2015, 3, 1)
#       times = schedule.occurrences_between(range_start, range_start + IceCube::ONE_WEEK)
#       expect(times.first).to eq Time.local(2015, 3, 1)
#     end

#     it 'should stay aligned to the start week when selecting occurrences with the spans option' do
#       t0 = Time.local(2017, 1, 15)
#       schedule = IceCube::Schedule.new(t0, duration: ONE_HOUR)
#       schedule.add_recurrence_rule IceCube::Rule.weekly(2).day(:sunday)
#       ts = schedule.occurrences_between(t0, t0 + ONE_WEEK * 4, spans: true)

#       expect(ts).to eq([t0, t0 + ONE_WEEK * 2, t0 + ONE_WEEK * 4])
#     end

#     context 'with Monday week start' do
#       it 'should align next_occurrences with first valid weekday when schedule starts on a Monday' do
#         schedule = IceCube::Schedule.new(Time.utc(2017, 6, 5))
#         except_tuesday = %i[monday wednesday thursday friday saturday sunday]
#         schedule.add_recurrence_rule IceCube::Rule.weekly(2, :monday).day(except_tuesday)
#         sample = [
#           Time.utc(2017,  6,  5),
#           Time.utc(2017,  6,  7),
#           Time.utc(2017,  6,  8),
#           Time.utc(2017,  6,  9),
#           Time.utc(2017,  6, 10),
#           Time.utc(2017,  6, 11),
#           Time.utc(2017,  6, 19)
#         ]

#         expect(schedule.first(7)).to eq sample
#         expect(schedule.next_occurrences(3, sample[4] - 1)).to eq sample[4..6]
#       end

#       it 'should align next_occurrence with first valid weekday when schedule starts on a Monday' do
#         t0 = Time.utc(2017, 6, 5)
#         schedule = IceCube::Schedule.new(t0)
#         schedule.add_recurrence_rule IceCube::Rule.weekly(2, :monday).day(:monday, :thursday)
#         sample = [
#           Time.utc(2017,  6, 5),
#           Time.utc(2017,  6, 8),
#           Time.utc(2017,  6, 19),
#           Time.utc(2017,  6, 22)
#         ]

#         expect(schedule.first(4)).to eq(sample)
#         expect(schedule.next_occurrence(sample[2] - 1)).to eq(sample[2])
#       end

#       it 'should align next_occurrence with first valid weekday when schedule starts on a Wednesday' do
#         t0 = Time.utc(2017, 6, 7)
#         schedule = IceCube::Schedule.new(t0)
#         schedule.add_recurrence_rule IceCube::Rule.weekly(2, :monday).day(:wednesday, :sunday)
#         sample = [
#           Time.utc(2017,  6, 7),
#           Time.utc(2017,  6, 11),
#           Time.utc(2017,  6, 21),
#           Time.utc(2017,  6, 25)
#         ]

#         expect(schedule.first(4)).to eq sample
#         expect(schedule.next_occurrence(sample[0] + 7 * ONE_DAY)).to eq sample[2]
#         expect(schedule.next_occurrence(sample[2] + ONE_DAY)).to eq sample[3]
#       end
#     end

#     it 'should align next_occurrence with the earliest hour validation' do
#       t0 = Time.utc(2017, 7, 28, 20, 30, 40)
#       schedule = IceCube::Schedule.new(t0)
#       schedule.add_recurrence_rule IceCube::Rule.weekly.day(:saturday).hour_of_day(19).minute_of_hour(29).second_of_minute(39)

#       expect(schedule.next_occurrence(t0)).to eq Time.utc(2017, 7, 29, 19, 29, 39)
#     end

#     describe 'using occurs_between with a biweekly schedule' do
#       [[0, 1, 2], [0, 6, 1], [5, 1, 6], [6, 5, 7]].each do |wday, offset, lead|
#         start_time    = Time.utc(2014, 1, 5, 9, 0, 0)
#         expected_time = start_time + (IceCube::ONE_DAY * 14)
#         offset_wday   = (wday + offset) % 7

#         context "starting on weekday #{wday} selecting weekday #{offset} with a #{lead} day advance window" do
#           let(:biweekly) { IceCube::Rule.weekly(2).day(0, 1, 2, 3, 4, 5, 6) }
#           let(:schedule) do
#             IceCube::Schedule.new(start_time + (IceCube::ONE_DAY * wday),
#                                   duration: IceCube::ONE_HOUR) do |s|
#               s.rrule biweekly
#             end
#           end
#           let(:expected_date) { expected_time + (IceCube::ONE_DAY * offset_wday) }
#           let(:range)         { [expected_date - (IceCube::ONE_DAY * lead), expected_date] }

#           it "should include weekday #{offset_wday} of the expected week" do
#             expect(schedule.occurrences_between(range.first, range.last)).to include expected_date
#           end

#           it "should include weekday #{offset_wday} of the expected week with the spans option" do
#             expect(schedule.occurrences_between(range.first, range.last, spans: true)).to include expected_date
#           end
#         end
#       end

#       context 'when day of start_time does not align with specified day rule' do
#         let(:start_time) { Time.utc(2018, 8, 7, 10, 0, 0) }
#         let(:end_time) { Time.utc(2018, 8, 7, 15, 0, 0) }
#         let(:biweekly) { IceCube::Rule.weekly(2).day(:saturday).hour_of_day(10) }
#         let(:schedule) { IceCube::Schedule.new(start_time, end_time: end_time) { |s| s.rrule biweekly } }
#         let(:range) { [Time.utc(2018, 8, 11, 7, 0, 0), Time.utc(2018, 8, 12, 6, 59, 59)] }
#         let(:expected_date) { Time.utc(2018, 8, 11, 10, 0, 0) }

#         it 'should align to the correct day with the spans option' do
#           expect(schedule.occurrences_between(range.first, range.last, spans: true)).to include expected_date
#         end
#       end
#     end

#     describe 'using occurs_between with a weekly schedule' do
#       [[6, 5, 7]].each do |wday, offset, lead|
#         start_week = Time.utc(2014, 1, 5)
#         expected_week = start_week + ONE_WEEK
#         offset_wday   = (wday + offset) % 7

#         context "starting on weekday #{wday} selecting weekday #{offset} with a #{lead} day advance window" do
#           let(:weekly)        { IceCube::Rule.weekly(1).day(0, 1, 2, 3, 4, 5, 6) }
#           let(:schedule)      { IceCube::Schedule.new(start_week + wday * IceCube::ONE_DAY) { |s| s.rrule weekly } }
#           let(:expected_date) { expected_week + offset_wday * IceCube::ONE_DAY }
#           let(:range)         { [expected_date - lead * ONE_DAY, expected_date] }

#           it "should include weekday #{offset_wday} of the expected week" do
#             wday_of_start_week = start_week + wday * IceCube::ONE_DAY

#             expect(schedule.occurrences_between(range.first, range.last)).to include expected_date
#             expect(schedule.occurrences_between(range.first, range.last).first).to eq(wday_of_start_week)
#           end
#         end
#       end
#     end
#   end
# end
