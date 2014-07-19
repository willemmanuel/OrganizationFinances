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

require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
