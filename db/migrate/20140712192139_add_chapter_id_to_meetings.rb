class AddChapterIdToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :chapter_id, :integer
  end
end
