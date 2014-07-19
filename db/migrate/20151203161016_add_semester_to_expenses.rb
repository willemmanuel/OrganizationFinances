class AddSemesterToExpenses < ActiveRecord::Migration
  def change
    add_reference :expenses, :semester, index: true
  end
end
