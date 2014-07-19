class RemoveUserIdFromChapter < ActiveRecord::Migration
  def change
    remove_column :chapters, :user_id, :integer
  end
end
