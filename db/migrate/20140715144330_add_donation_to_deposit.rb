class AddDonationToDeposit < ActiveRecord::Migration
  def change
    add_column :deposits, :donation, :boolean
  end
end
