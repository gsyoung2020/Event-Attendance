# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  factory :member do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.phone { Faker::Number.number(digits: 10) }
    f.birthday { '2021-07-17' }
    f.anniversary { '2021-07-17' }
  end
end
