class AddChapterIdToDeposit < ActiveRecord::Migration
  def change
    add_column :deposits, :chapter_id, :integer
  end
end
