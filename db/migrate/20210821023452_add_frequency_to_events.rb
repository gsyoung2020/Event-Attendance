# frozen_string_literal: true

class AddFrequencyToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :frequency, :string
  end
end
