class AddActiveToBrothers < ActiveRecord::Migration
  def change
    add_column :brothers, :active, :boolean
  end
end
