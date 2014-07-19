class AddCollectionToDebtsAndExpenses < ActiveRecord::Migration
  def change
  	add_column :debts, :collection_id, :integer
  	add_column :expenses, :collection_id, :integer
  end
end
