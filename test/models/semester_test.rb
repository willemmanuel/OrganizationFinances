# == Schema Information
#
# Table name: semesters
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  semester_id :integer
#  chapter_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  current     :boolean          default(FALSE)
#

require 'test_helper'

class SemesterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
