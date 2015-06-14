class AddTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :time_begin, :time
    add_column :events, :time_end, :time
  end
end
