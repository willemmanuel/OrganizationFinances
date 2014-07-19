# == Schema Information
#
# Table name: brothers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  phone      :string(255)
#  email      :string(255)
#  year       :integer
#  created_at :datetime
#  updated_at :datetime
#  demerit    :decimal(, )
#  chapter_id :integer
#  active     :boolean
#

require 'test_helper'

class BrotherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
