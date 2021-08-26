# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  factory :event do |f|
    f.description { Faker::String.description }
    f.start_time { Faker::Date.start_time }
    f.event_location { Faker::Address.event_location }
  end
end
