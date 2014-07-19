# == Schema Information
#
# Table name: collections
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  chapter_id  :integer
#  semester_id :integer
#

class Collection < ActiveRecord::Base
	belongs_to :semester
	has_many :debts
	has_many :expenses
end
