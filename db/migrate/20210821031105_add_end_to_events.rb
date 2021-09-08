# frozen_string_literal: true

class AddEndToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :end_time, :datetime
  end
end
