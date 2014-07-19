class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.date :date
      t.integer :attendance_id
      t.string :minutes

      t.timestamps
    end
  end
end
