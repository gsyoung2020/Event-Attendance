# frozen_string_literal: true

class AddStartToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :start_time, :datetime
  end
end
