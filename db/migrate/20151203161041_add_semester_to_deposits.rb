class AddSemesterToDeposits < ActiveRecord::Migration
  def change
    add_reference :deposits, :semester, index: true
  end
end
