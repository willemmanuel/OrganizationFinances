class AddSemesterToDebts < ActiveRecord::Migration
  def change
    add_reference :debts, :semester, index: true
  end
end
