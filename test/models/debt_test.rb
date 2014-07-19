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

require 'test_helper'

class DebtTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
