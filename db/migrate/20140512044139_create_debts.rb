class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.string :name
      t.integer :brother_id
      t.decimal :amount
      t.boolean :status
      t.date :issued
      t.date :paid
      t.text :notes

      t.timestamps
    end
  end
end
