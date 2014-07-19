# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
#  chapter    :string(255)
#  national   :string(255)
#  school     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Chapter < ActiveRecord::Base
	include ApplicationHelper

	has_many :users

	has_many :semesters, dependent: :destroy

	has_one :semester

	has_many :brothers, dependent: :destroy

	validates_presence_of :chapter
	validates_presence_of :national
	validates_presence_of :school

	def get_current_semester
		Semester.where(chapter_id: id, current: true).first
	end

	def get_latest_semester
		sem = get_current_semester
		while get_next_semester(sem) != nil
			sem = get_next_semester(sem)
		end
		return sem
	end
end
