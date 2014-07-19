class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.string :name
      t.decimal :budget
      t.integer :brother_id

      t.timestamps
    end
  end
end
