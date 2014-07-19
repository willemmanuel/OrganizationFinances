class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :meeting_id
      t.integer :brother_id
      t.string :status

      t.timestamps
    end
  end
end
