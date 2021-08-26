# frozen_string_literal: true

class EventsMembers < ApplicationRecord
  belongs_to :event
  belongs_to :member
end
