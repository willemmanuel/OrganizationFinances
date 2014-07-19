class AddChapterIdToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :chapter_id, :integer
  end
end
