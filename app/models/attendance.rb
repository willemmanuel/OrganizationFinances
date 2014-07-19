# == Schema Information
#
# Table name: attendances
#
#  id          :integer          not null, primary key
#  meeting_id  :integer
#  brother_id  :integer
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  chapter_id  :integer
#  semester_id :integer
#

class Attendance < ActiveRecord::Base
	belongs_to :semester
	belongs_to :meeting
	belongs_to :brother
end
