class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :category_id, :string
  end
end
