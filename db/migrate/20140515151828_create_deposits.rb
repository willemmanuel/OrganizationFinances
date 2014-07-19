class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.date :date
      t.decimal :amount
      t.string :name
      t.string :notes

      t.timestamps
    end
  end
end
