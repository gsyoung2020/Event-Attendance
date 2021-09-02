# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { FactoryBot.create(:event) }
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
  context 'schedule' do
    it 'should have an associated schedule' do
      expect(subject.schedule).to_not be_nil
    end
    it 'should return a hash' do
      expect(subject.schedule).to be_an_instance_of(IceCube::Schedule)
    end
    it 'should have a start time' do
      expect(subject.schedule(:start_time)).to_not be_nil
    end
    it 'should have an end time' do
      expect(subject.schedule(:end_time)).to_not be_nil
    end
    it 'should have recurrence rules' do
      expect(subject.schedule(:all_recurrence_rules)).to_not be_nil
    end
  end
  context 'can calendar events' do
    it 'has a calendar_events method that returns an array' do
      expect(subject.calendar_events(Time.now)).to be_an_instance_of(Array)
    end
    it 'returns an array with expected values' do
      expected_array = subject.calendar_events(Time.now)
      expect(subject.calendar_events(Time.now)).to eq(expected_array)
    end
  end
end
