# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject do
    Event.new(description: 'Sunday Service', start_time: '2021-07-17', end_time: '2021-09-17',
              event_location: '234 Gebroni Road, Raleigh, NC 12345')
  end
  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end
  it 'is not valid without a description' do
    subject.description = nil
    expect(subject).to_not be_valid
  end
  it 'is not valid without a start time' do
    subject.start_time = nil
    expect(subject).to_not be_valid
  end
  it 'is not valid without a location' do
    subject.event_location = nil
    expect(subject).to_not be_valid
  end
end
