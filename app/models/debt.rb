# == Schema Information
#
# Table name: debts
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  brother_id    :integer
#  amount        :decimal(, )
#  status        :boolean
#  due           :date
#  paid          :date
#  notes         :text
#  created_at    :datetime
#  updated_at    :datetime
#  chapter_id    :integer
#  collection_id :integer
#  semester_id   :integer
#

class Debt < ActiveRecord::Base
	belongs_to :semester
	belongs_to :brother
	belongs_to :collection

	def stripe_amount
		stripe = ((amount*0.029 + amount)*100+30)
		return stripe
	end

	def text_stripe_amount
		text = ((amount*0.029 + amount)+0.30)
		return text
	end
end
