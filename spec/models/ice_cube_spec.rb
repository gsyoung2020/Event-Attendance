# frozen_string_literal: true

require 'spec_helper'

module IceCube
  describe IceCube::Schedule do
    it 'should work with a simple schedule' do
      rule = IceCube::Rule.daily.day(:monday)
      schedule = IceCube::Schedule.new(Time.now)
      schedule.add_recurrence_rule rule
      expect { schedule.first(3) }.not_to raise_error
    end

    it 'should respond to complex combinations (1)' do
      start_time = Time.utc(2010, 1, 1)
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.yearly(2).day(:wednesday).month_of_year(:april)
      # check assumptions
      dates = schedule.occurrences(Time.utc(2011, 12, 31)) # two years
      expect(dates.size).to eq(4)
      dates.each do |date|
        expect(date.wday).to eq(3)
        expect(date.month).to eq(4)
        expect(date.year).to eq(start_time.year) # since we're doing every other
      end
    end

    it 'should return an added occurrence time' do
      schedule = IceCube::Schedule.new(t0 = Time.now)
      schedule.add_recurrence_time(t0 + 2)
      expect(schedule.occurrences(t0 + 50)).to eq([t0, t0 + 2])
    end

    it 'should not return an occurrence time that is excluded' do
      schedule = IceCube::Schedule.new(t0 = Time.now)
      schedule.add_recurrence_time(t0 + 2)
      schedule.add_exception_time(t0 + 2)
      expect(schedule.occurrences(t0 + 50)).to eq([t0])
    end

    it 'should return properly with a combination of a recurrence and exception rule' do
      schedule = IceCube::Schedule.new(DAY)
      schedule.add_recurrence_rule IceCube::Rule.daily # every day
      schedule.add_exception_rule IceCube::Rule.weekly.day(:monday, :tuesday, :wednesday) # except these
      # check assumption - in 2 weeks, we should have 8 days
      expect(schedule.occurrences(DAY + 13 * IceCube::ONE_DAY).size).to eq(8)
    end

    it 'should be able to exclude a certain date from a range' do
      start_time = Time.local 2012, 3, 1
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily
      schedule.add_exception_time(start_time + 1 * IceCube::ONE_DAY) # all days except tomorrow
      # check assumption
      dates = schedule.occurrences(start_time + 13 * IceCube::ONE_DAY) # 2 weeks
      expect(dates.size).to eq(13) # 2 weeks minus 1 day
      expect(dates).not_to include(start_time + 1 * IceCube::ONE_DAY)
    end

    it 'make a schedule with a start_time not included in a rule, and make sure that count behaves properly' do
      start_time = WEDNESDAY
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday).count(5)
      dates = schedule.all_occurrences
      expect(dates.uniq.size).to eq(5)
      dates.each { |d| expect(d.wday).to eq(4) }
      expect(dates).not_to include(WEDNESDAY)
    end

    it 'make a schedule with a start_time included in a rule, and make sure that count behaves properly' do
      start_time = WEDNESDAY + IceCube::ONE_DAY
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.weekly.day(:thursday).count(5)
      dates = schedule.all_occurrences
      expect(dates.uniq.size).to eq(5)
      dates.each { |d| expect(d.wday).to eq(4) }
      expect(dates).to include(WEDNESDAY + IceCube::ONE_DAY)
    end

    it 'should work as expected with a second_of_minute rule specified' do
      start_time = DAY
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.weekly.second_of_minute(30)
      dates = schedule.occurrences(start_time + 30 * 60)
      dates.each { |date| expect(date.sec).to eq(30) }
    end

    it 'ensure that when count on a rule is set to 0, 0 occurrences come back' do
      start_time = DAY
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily.count(0)
      expect(schedule.all_occurrences).to eq([])
    end

    it 'should be able to schedule at hour 1,2 with start min/sec every day' do
      start_time = Time.utc(2007, 9, 2, 9, 15, 25)
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily.hour_of_day(1, 2).count(6)
      dates = schedule.all_occurrences
      expect(dates).to eq([Time.utc(2007, 9, 3, 1, 15, 25), Time.utc(2007, 9, 3, 2, 15, 25),
                           Time.utc(2007, 9, 4, 1, 15, 25), Time.utc(2007, 9, 4, 2, 15, 25),
                           Time.utc(2007, 9, 5, 1, 15, 25), Time.utc(2007, 9, 5, 2, 15, 25)])
    end

    it 'should be able to schedule at hour 1,2 at min 0 with start sec every day' do
      start_time = Time.utc(2007, 9, 2, 9, 15, 25)
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily.hour_of_day(1, 2).minute_of_hour(0).count(6)
      dates = schedule.all_occurrences
      expect(dates).to eq([Time.utc(2007, 9, 3, 1, 0, 25), Time.utc(2007, 9, 3, 2, 0, 25),
                           Time.utc(2007, 9, 4, 1, 0, 25), Time.utc(2007, 9, 4, 2, 0, 25),
                           Time.utc(2007, 9, 5, 1, 0, 25), Time.utc(2007, 9, 5, 2, 0, 25)])
    end

    it 'will only return count# if you specify a count and use .first' do
      start_time = Time.now
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily.count(10)
      dates = schedule.first(200)
      expect(dates.size).to eq(10)
    end

    it 'occurs yearly' do
      start_time = DAY
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.yearly
      dates = schedule.first(10)
      dates.each do |date|
        expect(date.month).to eq(start_time.month)
        expect(date.day).to eq(start_time.day)
        expect(date.hour).to eq(start_time.hour)
        expect(date.min).to eq(start_time.min)
        expect(date.sec).to eq(start_time.sec)
      end
    end

    it 'occurs daily' do
      start_time = Time.now
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily
      dates = schedule.first(10)
      dates.each do |date|
        expect(date.hour).to eq(start_time.hour)
        expect(date.min).to eq(start_time.min)
        expect(date.sec).to eq(start_time.sec)
      end
    end

    it 'occurs hourly' do
      start_time = Time.now
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.hourly
      dates = schedule.first(10)
      dates.each do |date|
        expect(date.min).to eq(start_time.min)
        expect(date.sec).to eq(start_time.sec)
      end
    end

    it 'occurs minutely' do
      start_time = Time.now
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.minutely
      dates = schedule.first(10)
      dates.each do |date|
        expect(date.sec).to eq(start_time.sec)
      end
    end

    it 'occurs every second for an hour' do
      start_time = Time.now
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.secondly.count(60)
      # build the expectation list
      expectation = []
      0.upto(59) { |i| expectation << start_time + i }
      # compare with what we get
      dates = schedule.all_occurrences
      expect(dates.size).to eq(60)
      expect(schedule.all_occurrences).to eq(expectation)
    end

    it 'perform a every day LOCAL and make sure we get back LOCAL' do
      Time.zone = 'Eastern Time (US & Canada)'
      start_time = Time.zone.local(2010, 9, 2, 5, 0, 0)
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily
      schedule.first(10).each do |d|
        expect(d.utc?).to eq(false)
        expect(d.hour).to eq(5)
        expect(d.utc_offset == -5 * IceCube::ONE_HOUR || d.utc_offset == -4 * IceCube::ONE_HOUR).to be_truthy
      end
    end

    it 'perform a every day LOCAL and make sure we get back LOCAL' do
      start_time = Time.utc(2010, 9, 2, 5, 0, 0)
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily
      schedule.first(10).each do |d|
        expect(d.utc?).to eq(true)
        expect(d.utc_offset).to eq(0)
        expect(d.hour).to eq(5)
      end
    end

    # here we purposely put a UTC time that is before the range ends, to
    # verify ice_cube is properly checking until bounds
    it 'works with a until date that is UTC, but the start date is local' do
      Time.zone = 'Eastern Time (US & Canada)'
      start_time = Time.zone.local(2010, 11, 6, 5, 0, 0)
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily.until(Time.utc(2010, 11, 10, 8, 0, 0)) # 4 o clocal local
      # check assumptions
      dates = schedule.all_occurrences
      dates.each { |d| expect(d.utc?).to eq(false) }
      expect(dates).to eq([Time.zone.local(2010, 11, 6, 5, 0, 0),
                           Time.zone.local(2010, 11, 7, 5, 0, 0), Time.zone.local(2010, 11, 8, 5, 0, 0),
                           Time.zone.local(2010, 11, 9, 5, 0, 0)])
    end

    # here we purposely put a local time that is before the range ends, to
    # verify ice_cube is properly checking until bounds
    it 'works with a until date that is local, but the start date is UTC' do
      start_time = Time.utc(2010, 11, 6, 5, 0, 0)
      Time.zone = 'Eastern Time (US & Canada)'
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily.until(Time.zone.local(2010, 11, 9, 23, 0, 0)) # 4 o UTC time
      # check assumptions
      dates = schedule.all_occurrences
      dates.each { |d| expect(d.utc?).to eq(true) }
      expect(dates).to eq([Time.utc(2010, 11, 6, 5, 0, 0),
                           Time.utc(2010, 11, 7, 5, 0, 0), Time.utc(2010, 11, 8, 5, 0, 0),
                           Time.utc(2010, 11, 9, 5, 0, 0)])
    end

    it 'works with a monthly rule iterating on UTC' do
      start_time = Time.utc(2010, 4, 24, 15, 45, 0)
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.monthly
      dates = schedule.first(10)
      dates.each do |d|
        expect(d.day).to eq(24)
        expect(d.hour).to eq(15)
        expect(d.min).to eq(45)
        expect(d.sec).to eq(0)
        expect(d.utc?).to be_truthy
      end
    end

    it 'can retrieve rrules from a schedule' do
      schedule = IceCube::Schedule.new(Time.now)
      rules = [IceCube::Rule.daily, IceCube::Rule.monthly, IceCube::Rule.yearly]
      rules.each { |r| schedule.add_recurrence_rule(r) }
      # pull the rules back out of the schedule and compare
      expect(schedule.rrules).to eq(rules)
    end

    it 'can retrieve exrules from a schedule' do
      schedule = IceCube::Schedule.new(Time.now)
      rules = [IceCube::Rule.daily, IceCube::Rule.monthly, IceCube::Rule.yearly]
      rules.each { |r| schedule.add_exception_rule(r) }
      # pull the rules back out of the schedule and compare
      expect(schedule.exrules).to eq(rules)
    end

    it 'can retrieve recurrence times from a schedule' do
      schedule = IceCube::Schedule.new(Time.now)
      times = [Time.now, Time.now + 5, Time.now + 10]
      times.each { |d| schedule.add_recurrence_time(d) }
      # pull the dates back out of the schedule and compare
      expect(schedule.rtimes).to eq(times)
    end

    it 'can retrieve exception_times from a schedule' do
      schedule = IceCube::Schedule.new(Time.now)
      times = [Time.now, Time.now + 5, Time.now + 10]
      times.each { |d| schedule.add_exception_time(d) }
      # pull the dates back out of the schedule and compare
      expect(schedule.extimes).to eq(times)
    end

    it 'can reuse the same rule' do
      schedule = IceCube::Schedule.new(Time.now)
      rule = IceCube::Rule.daily
      schedule.add_recurrence_rule rule
      result1 = schedule.first(10)
      rule.day(:monday)
      # check to make sure the change affected the rule
      expect(schedule.first(10)).not_to eq(result1)
    end

    it 'ensures that month of year (3) is march' do
      schedule = IceCube::Schedule.new(DAY)
      schedule.add_recurrence_rule IceCube::Rule.daily.month_of_year(:march)

      schedule2 = IceCube::Schedule.new(DAY)
      schedule2.add_recurrence_rule IceCube::Rule.daily.month_of_year(3)

      expect(schedule.first(10)).to eq(schedule2.first(10))
    end

    it 'ensures that day of week (1) is monday' do
      schedule = IceCube::Schedule.new(DAY)
      schedule.add_recurrence_rule IceCube::Rule.daily.day(:monday)

      schedule2 = IceCube::Schedule.new(DAY)
      schedule2.add_recurrence_rule IceCube::Rule.daily.day(1)

      expect(schedule.first(10)).to eq(schedule2.first(10))
    end

    it 'should be able to find occurrences between two dates which are both in the future' do
      start_time = Time.local(2012, 5, 1)
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily
      dates = schedule.occurrences_between(start_time + IceCube::ONE_DAY * 2, start_time + IceCube::ONE_DAY * 4)
      expect(dates).to eq([start_time + IceCube::ONE_DAY * 2, start_time + IceCube::ONE_DAY * 3,
                           start_time + IceCube::ONE_DAY * 4])
    end

    it 'should be able to specify an end time for the schedule' do
      start_time = DAY
      end_time = DAY + IceCube::ONE_DAY * 2
      schedule = IceCube::Schedule.new(start_time)
      schedule.add_recurrence_rule IceCube::Rule.daily.until(end_time)
      expect(schedule.all_occurrences).to eq([DAY, DAY + 1 * IceCube::ONE_DAY, DAY + 2 * IceCube::ONE_DAY])
    end

    it 'should not create an infinite loop crossing over february - github issue 6' do
      schedule = IceCube::Schedule.new(Time.parse('2010-08-30'))
      schedule.add_recurrence_rule IceCube::Rule.monthly(6)
      schedule.occurrences_between(Time.parse('2010-07-01'), Time.parse('2010-09-01'))
    end

    it 'should be able to exist on the 28th of each month crossing over february - github issue 6a' do
      schedule = IceCube::Schedule.new(Time.local(2010, 1, 28))
      schedule.add_recurrence_rule IceCube::Rule.monthly
      expect(schedule.first(3)).to eq([Time.local(2010, 1, 28), Time.local(2010, 2, 28), Time.local(2010, 3, 28)])
    end

    it 'should be able to exist on the 29th of each month crossing over february - github issue 6a' do
      schedule = IceCube::Schedule.new(Time.zone.local(2010, 1, 29))
      schedule.add_recurrence_rule IceCube::Rule.monthly
      expect(schedule.first(3)).to eq([Time.zone.local(2010, 1, 29), Time.zone.local(2010, 2, 28),
                                       Time.zone.local(2010, 3, 29)])
    end

    it 'should be able to exist on the 30th of each month crossing over february - github issue 6a' do
      schedule = IceCube::Schedule.new(Time.zone.local(2010, 1, 30))
      schedule.add_recurrence_rule IceCube::Rule.monthly
      expect(schedule.first(3)).to eq([Time.zone.local(2010, 1, 30), Time.zone.local(2010, 2, 28),
                                       Time.zone.local(2010, 3, 30)])
    end

    it 'should be able to exist ont he 31st of each month crossing over february - github issue 6a' do
      schedule = IceCube::Schedule.new(Time.zone.local(2010, 1, 31))
      schedule.add_recurrence_rule IceCube::Rule.monthly
      expect(schedule.first(3)).to eq([Time.zone.local(2010, 1, 31), Time.zone.local(2010, 2, 28),
                                       Time.zone.local(2010, 3, 31)])
    end

    it 'should deal with a yearly rule that has februaries with different mdays' do
      schedule = IceCube::Schedule.new(Time.local(2008, 2, 29))
      schedule.add_recurrence_rule IceCube::Rule.yearly
      expect(schedule.first(3)).to eq([Time.local(2008, 2, 29), Time.local(2009, 2, 28), Time.local(2010, 2, 28)])
    end

    it 'should work with every other month even when the day of the month iterating on does not exist' do
      schedule = IceCube::Schedule.new(Time.zone.local(2010, 1, 31))
      schedule.add_recurrence_rule IceCube::Rule.monthly(2)
      expect(schedule.first(6)).to eq([Time.zone.local(2010, 1, 31), Time.zone.local(2010, 3, 31),
                                       Time.zone.local(2010, 5, 31), Time.zone.local(2010, 7, 31), Time.zone.local(2010, 9, 30), Time.zone.local(2010, 11, 30)])
    end

    it 'should be able to go into february and stay on the same day' do
      schedule = IceCube::Schedule.new(Time.local(2010, 1, 5))
      schedule.add_recurrence_rule IceCube::Rule.monthly
      expect(schedule.first(2)).to eq([Time.local(2010, 1, 5), Time.local(2010, 2, 5)])
    end

    it 'should have some convenient aliases' do
      start_time = Time.now
      schedule = IceCube::Schedule.new(start_time)

      expect(schedule.start_time).to eq(schedule.start_time)
      expect(schedule.end_time).to eq(schedule.end_time)
    end

    it 'should have some convenient alias for rrules' do
      schedule = IceCube::Schedule.new(Time.now)
      daily = IceCube::Rule.daily; monthly = IceCube::Rule.monthly
      schedule.add_recurrence_rule daily
      schedule.rrule monthly
      expect(schedule.rrules).to eq([daily, monthly])
    end

    it 'should have some convenient alias for exrules' do
      schedule = IceCube::Schedule.new(Time.now)
      daily = IceCube::Rule.daily; monthly = IceCube::Rule.monthly
      schedule.add_exception_rule daily
      schedule.exrule monthly
      expect(schedule.exrules).to eq([daily, monthly])
    end

    it 'should have some convenient alias for recurrence_times' do
      schedule = IceCube::Schedule.new(Time.now)
      schedule.add_recurrence_time Time.local(2010, 8, 13)
      schedule.rtime Time.local(2010, 8, 14)
      expect(schedule.rtimes).to eq([Time.local(2010, 8, 13), Time.local(2010, 8, 14)])
    end

    it 'should have some convenient alias for extimes' do
      schedule = IceCube::Schedule.new(Time.now)
      schedule.add_exception_time Time.local(2010, 8, 13)
      schedule.extime Time.local(2010, 8, 14)
      expect(schedule.extimes).to eq([Time.local(2010, 8, 13), Time.local(2010, 8, 14)])
    end

    it 'should be able to have a rule and an exrule' do
      schedule = IceCube::Schedule.new(Time.local(2010, 8, 27, 10))
      schedule.rrule IceCube::Rule.daily
      schedule.exrule IceCube::Rule.daily.day(:friday)
      expect(schedule.occurs_on?(Date.new(2010, 8, 27))).to be_falsey
      expect(schedule.occurs_on?(Date.new(2010, 8, 28))).to be_truthy
    end

    it 'should always generate the correct number of days for .first' do
      s = IceCube::Schedule.new(Time.zone.parse('1-1-1985'))
      r = IceCube::Rule.weekly(3).day(:monday, :wednesday, :friday)
      s.add_recurrence_rule(r)
      # test sizes
      expect(s.first(3).size).to eq(3)
      expect(s.first(4).size).to eq(4)
      expect(s.first(5).size).to eq(5)
    end

    it 'should use current date as start date when invoked with a nil parameter' do
      schedule = IceCube::Schedule.new nil
      expect(Time.now - schedule.start_time).to be < 100
    end

    it 'should be able to get the occurrence count for a rule' do
      rule = IceCube::Rule.daily.count(5)
      expect(rule.occurrence_count).to eq(5)
    end

    it 'should be able to remove a count validation from a rule' do
      rule = IceCube::Rule.daily.count(5)
      expect(rule.occurrence_count).to eq(5)
      rule.count(nil)
      expect(rule.occurrence_count).to be_nil
    end

    it 'should be able to remove a count validation from a rule' do
      rule = IceCube::Rule.daily.count(5)
      expect(rule.to_hash[:count]).to eq(5)
      rule.count nil
      expect(rule.to_hash[:count]).to be_nil
    end

    it 'should be able to remove an until validation from a rule' do
      rule = IceCube::Rule.daily.until(Time.now + IceCube::ONE_DAY)
      expect(rule.to_hash[:until]).not_to be_nil
      rule.until nil
      expect(rule.to_hash).not_to have_key(:until)
    end

    it 'should not have ridiculous load times for minutely on next_occurrence (from sidetiq)' do
      quick_attempt_test do
        IceCube::Schedule.new(Time.utc(2010, 1, 1)) do |s|
          s.add_recurrence_rule(IceCube::Rule.minutely(1800))
        end
      end
    end

    it 'should not have ridiculous load times for every 10 on next_occurrence #210' do
      quick_attempt_test do
        IceCube::Schedule.new(Time.utc(2010, 1, 1)) do |s|
          s.add_recurrence_rule(IceCube::Rule.hourly.minute_of_hour(0, 10, 20, 30, 40, 50))
        end
      end
      quick_attempt_test do
        IceCube::Schedule.new(Time.utc(2010, 1, 1)) do |s|
          s.add_recurrence_rule(IceCube::Rule.daily)
        end
      end
    end

    def quick_attempt_test
      time = Time.now
      10.times do
        (yield).next_occurrence(Time.now)
      end
      total = Time.now - time
      expect(total).to be < 0.1
    end
  end

  describe DailyRule, 'interval validation' do
    it 'converts a string integer to an actual int when using the interval method' do
      rule = Rule.daily.interval('2')
      expect(rule.validations_for(:interval).first.interval).to eq(2)
    end

    it 'converts a string integer to an actual int when using the initializer' do
      rule = Rule.daily('3')
      expect(rule.validations_for(:interval).first.interval).to eq(3)
    end

    it 'raises an argument error when a bad value is passed using the interval method' do
      expect do
        Rule.daily.interval('invalid')
      end.to raise_error(ArgumentError, "'invalid' is not a valid input for interval. Please pass a postive integer.")
    end

    it 'raises an argument error when a bad value is passed' do
      expect do
        Rule.daily('invalid')
      end.to raise_error(ArgumentError, "'invalid' is not a valid input for interval. Please pass a postive integer.")
    end
  end
end
