class AddChapterIdToBrothers < ActiveRecord::Migration
  def change
    add_column :brothers, :chapter_id, :integer
  end
end
