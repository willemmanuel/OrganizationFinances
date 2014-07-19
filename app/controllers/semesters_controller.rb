class SemestersController < ApplicationController

  include ApplicationHelper

  before_filter :require_chapter_manager

  def new
    @semester = Semester.new
  end

  def create
    @semester = Semester.new(semester_params)
    @semester.chapter = current_user.chapter
    @semester.semester = current_user.chapter.get_latest_semester
    if @semester.save
      redirect_to manage_path, notice: 'Semester successfully created.'
    else
      render action: 'new'
    end
  end

  def set_current_semester
    sem = Semester.where(id: params[:semester]).first
    if sem == nil
      redirect_to :back, notice: 'No semester given'
    end
    Semester.update_all(current: false)
    sem.current = true
    sem.save
    redirect_to :back, notice: "Semester updated"
  end

  private
  def semester_params
    params.require(:semester).permit(:name)
  end
  def require_chapter_manager
    if !current_user.present?
      return
    end
    unless current_user.chapter_manager
      redirect_to personal_path
    end
  end
end
