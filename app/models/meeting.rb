# == Schema Information
#
# Table name: meetings
#
#  id            :integer          not null, primary key
#  date          :date
#  attendance_id :integer
#  minutes       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  chapter_id    :integer
#  semester_id   :integer
#

class Meeting < ActiveRecord::Base
	belongs_to :semester
	has_many :attendances, dependent: :destroy
	accepts_nested_attributes_for :attendances, :reject_if => lambda { |a| a[:brother_id].blank? }, allow_destroy: true

	def quorum?
		return (self.attendances.where(status: "present").count.to_f / Brother.count) >= 0.5
	end

end
