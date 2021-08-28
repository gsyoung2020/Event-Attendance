# frozen_string_literal: true

class RemoveEndFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :end, :datetime
  end
end
