# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
#  chapter    :string(255)
#  national   :string(255)
#  school     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ChapterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
