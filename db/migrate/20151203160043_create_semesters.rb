class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :name
      t.references :semester, index: true
      t.references :chapter, index: true

      t.timestamps
    end
  end
end
