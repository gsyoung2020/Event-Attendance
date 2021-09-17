# frozen_string_literal: true

class Member < ApplicationRecord
  has_and_belongs_to_many :events
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates :phone, numericality: { only_integer: true }
  validates :phone, length: { is: 10 }
  validates :birthday, presence: true
  # validates_presence_of :name

  def full_name
    "#{first_name} #{last_name}"
  end

  def date_convert
    strftime('%m-%d')
  end
end
