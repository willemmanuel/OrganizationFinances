class MeetingsController < ApplicationController

  include ApplicationHelper

  before_action :set_meeting, only: [:show, :edit, :update, :destroy]
  before_action :set_attendance, only: [:toggle_attendance]
  before_action :set_semester, only: [:index]
  before_filter :require_chapter_manager

  def new
    @meeting = Meeting.new
    current_user.chapter.brothers.where(active: true).all.each do |b|
      @meeting.attendances.build(:brother => b, :semester => current_user.chapter.get_current_semester)
    end
    @meeting.date = Date.today
  end

  def edit
  end

  def index
    @meetings = @semester.meetings.all
  end

  def show
    @brothers_count = current_user.chapter.brothers.where(active: true).all.count
    @present_count = @meeting.attendances.where(status: "present").count
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.semester = current_user.chapter.get_current_semester
    if @meeting.save
      @meeting.attendances.where(status: "excused").each do |a|
        a.brother.demerit = a.brother.demerit + (1.0/3.0)
        a.brother.save
      end
      @meeting.attendances.where(status: "unexcused").each do |a|
        a.brother.demerit = a.brother.demerit + 1.0
        a.brother.save
      end
      redirect_to @meeting, notice: 'Meeting successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    @meeting.attendances.where(status: "unexcused").each do |a|
      a.brother.demerit = a.brother.demerit - 1.0
      a.brother.save
    end
    @meeting.attendances.where(status: "excused").each do |a|
      a.brother.demerit = a.brother.demerit - (1.0/3.0)
      a.brother.save
    end
    if @meeting.update(meeting_params)
      @meeting.attendances.where(status: "excused").each do |a|
        a.brother.demerit = a.brother.demerit + (1.0/3.0)
        a.brother.save
      end
      @meeting.attendances.where(status: "unexcused").each do |a|
        a.brother.demerit = a.brother.demerit + 1.0
        a.brother.save
      end
      redirect_to @meeting, notice: 'Meeting was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @meeting.attendances.where(status: "unexcused").each do |a|
      a.brother.demerit = a.brother.demerit - 1.0
      a.brother.save
    end
    @meeting.attendances.where(status: "excused").each do |a|
      a.brother.demerit = a.brother.demerit - (1.0/3.0)
      a.brother.save
    end
    @meeting.destroy
    redirect_to meetings_path
  end

  def toggle_attendance
    if @attendance.status == "present"
      @attendance.status = "justified"
    elsif @attendance.status == "justified"
      @attendance.status = "excused"
      @attendance.brother.demerit = @attendance.brother.demerit + (1.0/3.0)
      @attendance.brother.save
    elsif @attendance.status == "excused"
      @attendance.status = "unexcused"
      @attendance.brother.demerit = @attendance.brother.demerit + (2.0/3.0)
      @attendance.brother.save
    else
      @attendance.status = "present"
      @attendance.brother.demerit = @attendance.brother.demerit - 1.0
      @attendance.brother.save
    end
    @attendance.save
    redirect_to :back, :notice => "Attendance toggled"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    def set_semester
      @semester = get_semester(current_user.chapter, params[:semester])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_params
      params.require(:meeting).permit(:id, :brother_id, :date, :minutes, attendances_attributes: [:id, :brother_id, :status, :meeting_id])
    end

    def set_attendance
      @attendance = Attendance.find(params[:id])
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
