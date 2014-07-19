class AddPostedToDeposit < ActiveRecord::Migration
  def change
    add_column :deposits, :posted, :boolean
  end
end
