class AddChapterIdToCommittees < ActiveRecord::Migration
  def change
    add_column :committees, :chapter_id, :integer
  end
end
