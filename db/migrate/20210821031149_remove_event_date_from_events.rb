# frozen_string_literal: true

class RemoveEventDateFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :event_date, :datetime
  end
end
