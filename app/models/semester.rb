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

class Semester < ActiveRecord::Base
  belongs_to :chapter

  belongs_to :semester

  has_many :expenses, dependent: :destroy, order: "date DESC"
  has_many :debts, dependent: :destroy, order: "due DESC"
  has_many :deposits, dependent: :destroy, order: "date DESC"
  has_many :committees, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :meetings, dependent: :destroy, order: "date DESC"

  def get_rollover
    roll = deposits.all.sum(&:amount) - expenses.all.sum(&:amount)
    roll += semester.get_rollover unless semester == nil
    return 0 if roll == nil
    return roll
  end

  def next_semester
    s = Semester.where(chapter_id: chapter.id, semester_id: id).first
    if s
      return s
    else
      return nil
    end
  end

  def previous_semester
    return semester
  end

end
