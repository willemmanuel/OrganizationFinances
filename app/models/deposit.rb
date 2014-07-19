# == Schema Information
#
# Table name: deposits
#
#  id          :integer          not null, primary key
#  date        :date
#  amount      :decimal(, )
#  name        :string(255)
#  notes       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  chapter_id  :integer
#  donation    :boolean
#  posted      :boolean
#  semester_id :integer
#

class Deposit < ActiveRecord::Base
	belongs_to :semester
end
