class CreateBrothers < ActiveRecord::Migration
  def change
    create_table :brothers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.integer :year

      t.timestamps
    end
  end
end
