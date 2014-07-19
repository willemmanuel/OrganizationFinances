class AddPostedToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :posted, :boolean
  end
end
