class AddIsChapterManagerAndBrotherToUser < ActiveRecord::Migration
  def change
    add_column :users, :chapter_manager, :boolean
    add_column :users, :brother_id, :integer
  end
end
