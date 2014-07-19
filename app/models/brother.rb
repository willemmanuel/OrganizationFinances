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

class Brother < ActiveRecord::Base
	belongs_to :chapter

	has_many :debts
	has_many :expenses
	has_many :committees
	has_many :attendances, dependent: :destroy

  has_one :user

	validates_presence_of :name
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_length_of :phone, :is => 11

	def first_name
    	self.name.split(' ')[0]
  end
  def last_name
    	self.name.split(' ')[1]
  end

  def self.search(search)
  	  if search
   	    find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
      else
        find(:all)
      end
    end
end
