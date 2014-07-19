class AddChapterToCollections < ActiveRecord::Migration
  def change
  	add_column :collections, :chapter_id, :integer
  end
end
