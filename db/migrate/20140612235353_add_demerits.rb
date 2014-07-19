class AddDemerits < ActiveRecord::Migration
  def change
  	add_column :brothers, :demerit, :decimal
  end
end
