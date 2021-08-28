# frozen_string_literal: true

require 'rails_helper'
require 'simple_calendar'

RSpec.describe SimpleCalendar::Calendar, focus: true do
  let(:calendar) { SimpleCalendar::Calendar.new(nil) }

  it 'renders a partial with the same name as its class' do
    expect(calendar.send(:partial_name)).to eq('../../app/views/events/calendar')
  end

  it 'has a param that determines the start date of the calendar'
  it 'generates a default date if no start is present'
  it 'has a range of dates'
  it 'can split the range of dates into weeks'
  it 'has a title'
  it 'has a next view link'
  it 'has a previous view link'
  it 'accepts an array of events'
  it 'sorts the events'
  it 'yields the events for each day'
  it 'doesnt crash when an event has a nil start_time'
end
