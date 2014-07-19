class AddSemesterToAttendances < ActiveRecord::Migration
  def change
    add_reference :attendances, :semester, index: true
  end
end
