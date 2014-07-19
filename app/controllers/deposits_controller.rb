class DepositsController < ApplicationController

  before_action :set_deposit, only: [:show, :edit, :update, :destroy, :toggle_deposit_posted]

  before_filter :require_chapter_manager

  def show
    redirect_to edit_deposit_path(@deposit)
  end

  def new
    @deposit = Deposit.new
    @deposit.date = Date.today
    @deposit.posted = true
  end

  def edit
  end

  def create
  	@deposit = Deposit.new(deposit_params)
    @deposit.semester = current_user.chapter.get_current_semester
  	@deposit.save
  	redirect_to expenses_path, notice: 'Deposit was successfully created.'
  end

  def update
  	@deposit.update(deposit_params)
  	redirect_to expenses_path, notice: 'Deposit was successfully updated.'
  end

  def destroy
  	@deposit.destroy
  	redirect_to expenses_path, notice: 'Deposit destroyed.'
  end

  def toggle_deposit_posted
    @deposit.toggle!(:posted)
    @deposit.save
    redirect_to :back, :notice => "Posted status toggled"
  end

  private
	def set_deposit
	  @deposit = Deposit.find(params[:id])
	end

	def deposit_params
      params.require(:deposit).permit(:name, :amount, :date, :notes, :donation, :posted)
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
