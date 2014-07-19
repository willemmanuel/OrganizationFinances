class AddChapterIdToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :chapter_id, :integer
  end
end
