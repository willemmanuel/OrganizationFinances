class IntToDecimal < ActiveRecord::Migration
  def self.up
  	change_column :debts, :amount, :decimal
  	change_column :deposits, :amount, :decimal
  	change_column :expenses, :amount, :decimal
  	change_column :deposits, :amount, :decimal
  end
end
