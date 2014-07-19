class ChaptersController < ApplicationController
	before_filter :require_chapter_manager

	def index
		@chapter = current_user.chapter
		@users = current_user.chapter.users
		@semesters = current_user.chapter.semesters
	end

	private
	  def require_chapter_manager
	    if !current_user.present?
	      return
	    end
	    unless current_user.chapter_manager
	      redirect_to personal_path
	    end
	  end
end
