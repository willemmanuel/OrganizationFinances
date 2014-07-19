class AddChapterIdToDebts < ActiveRecord::Migration
  def change
    add_column :debts, :chapter_id, :integer
  end
end
