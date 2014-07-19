class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.integer :user_id
      t.string :chapter
      t.string :national
      t.string :school

      t.timestamps
    end
  end
end
