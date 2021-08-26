# frozen_string_literal: true

class Event < ApplicationRecord
  has_and_belongs_to_many :members
  validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :event_location, presence: true

  def schedule(start = Time.zone.now.to_date)
    IceCube::Schedule.new(start) do |s|
      s.add_recurrence_rule IceCube::Rule.daily.until(Date.today + 180) if frequency === 'Daily'
      s.add_recurrence_rule IceCube::Rule.weekly.until(Date.today + 365) if frequency === 'Weekly'
      s.add_recurrence_rule IceCube::Rule.monthly.until(Date.today + 500) if frequency === 'Monthly'
      s.add_recurrence_rule IceCube::Rule.annually.until(Date.today + 1000) if frequency === 'Annually'
    end
  end

  def calendar_events(start)
    start_date = start.beginning_of_month.beginning_of_week
    end_date = start.end_of_month.end_of_week
    schedule(start_date).occurrences(end_date).map do |date|
      Event.new(id: id, description: description, frequency: frequency, start_time: date)
    end
  end
end
