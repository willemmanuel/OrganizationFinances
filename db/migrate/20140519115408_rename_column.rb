class RenameColumn < ActiveRecord::Migration
  def change
  	rename_column :debts, :issued, :due
  end
end
