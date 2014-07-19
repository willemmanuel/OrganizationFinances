# == Schema Information
#
# Table name: expenses
#
#  id            :integer          not null, primary key
#  date          :date
#  brother_id    :integer
#  committee_id  :integer
#  item          :string(255)
#  reimbursed    :boolean
#  notes         :string(255)
#  amount        :decimal(, )
#  created_at    :datetime
#  updated_at    :datetime
#  chapter_id    :integer
#  posted        :boolean
#  collection_id :integer
#  semester_id   :integer
#

require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
