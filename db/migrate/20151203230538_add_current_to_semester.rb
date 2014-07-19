class AddCurrentToSemester < ActiveRecord::Migration
  def change
    add_column :semesters, :current, :boolean, :default => false
  end
end
