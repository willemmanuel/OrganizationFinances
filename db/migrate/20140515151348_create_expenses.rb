class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.date :date
      t.integer :brother_id
      t.integer :committee_id
      t.string :item
      t.boolean :reimbursed
      t.string :notes
      t.decimal :amount

      t.timestamps
    end
  end
end
