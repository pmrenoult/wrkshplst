class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.date :date_begin
      t.date :date_end

      t.timestamps null: false
    end
  end
end
