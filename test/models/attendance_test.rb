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

require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
