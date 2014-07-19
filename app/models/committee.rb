# == Schema Information
#
# Table name: committees
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  budget      :decimal(, )
#  brother_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  chapter_id  :integer
#  semester_id :integer
#

class Committee < ActiveRecord::Base
	belongs_to :semester
	has_many :expenses, dependent: :destroy, order: "date DESC"
	belongs_to :brother
end
