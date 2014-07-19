class AddSemesterToCommittees < ActiveRecord::Migration
  def change
    add_reference :committees, :semester, index: true
  end
end
