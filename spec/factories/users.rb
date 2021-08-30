# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  factory :user do |f|
    f.email { Faker::Internet.safe_email }
    f.password { Faker::Internet.password(min_length: 8) }
  end
end
