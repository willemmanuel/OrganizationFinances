class AddSemesterToCollections < ActiveRecord::Migration
  def change
    add_reference :collections, :semester, index: true
  end
end
