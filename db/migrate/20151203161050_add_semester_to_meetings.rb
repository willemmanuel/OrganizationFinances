class AddSemesterToMeetings < ActiveRecord::Migration
  def change
    add_reference :meetings, :semester, index: true
  end
end
