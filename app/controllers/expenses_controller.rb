class ExpensesController < ApplicationController
  include ApplicationHelper

  before_action :set_expense, only: [:show, :edit, :update, :destroy, :toggle_reimbursed, :toggle_posted]
  before_action :set_semester, only: [:index, :not_reimbursed, :not_posted]
  before_filter :require_chapter_manager

  def new
    @expense = Expense.new
    @expense.posted = true
    @expense.reimbursed = true
    @brothers = current_user.chapter.brothers.where(active: true).all
    @committees = current_user.chapter.get_current_semester.committees.all
    @collections = current_user.chapter.get_current_semester.collections.all
  end

  def edit
    @brothers = current_user.chapter.brothers.where(active: true).all
    @committees = current_user.chapter.get_current_semester.committees.all
    @collections = current_user.chapter.get_current_semester.collections.all
  end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: 'Expense was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Expense deleted"
  end

  def index
    # categories of deposits, expenses, and debts
    @all_deposits_plus_unposted = @semester.deposits
    @deposits = @semester.deposits.where(posted: true)
    @debts = @semester.debts.where(status: false).all
    @payments = @semester.debts.where(status: true).all
    @overdue = @semester.debts.where(status: false).where("due <= ?", Date.today).all
    @future = @semester.debts.where(status: false).where("due > ?", Date.today).all
    @collections = @semester.collections.all
    @future_expenses = @semester.expenses.where('date > ?', Date.today)
    @current_expenses = @semester.expenses.where('date <= ?', Date.today)
    @current_expenses_paginated = @semester.expenses.where('date <= ?', Date.today).paginate(:per_page => 10, :page => params[:current_page])
    @future_expenses_paginated = @semester.expenses.where('date > ?', Date.today).paginate(:per_page => 10, :page => params[:future_page])
    @all_deposits_plus_unposted_paginated = @semester.deposits.paginate(:per_page => 10, :page => params[:deposit_page])
    @expenses = @semester.expenses.all

    if @semester.previous_semester != nil
      @past_rollover = @semester.previous_semester.get_rollover
    else
      @past_rollover = 0
    end

    # different balance calculations
    @not_yet_posted = @semester.expenses.where('date <= ?', Date.today).where(posted: false).sum(&:amount)
    @not_yet_deposited = @semester.debts.where(status: true).sum(&:amount) - @semester.deposits.where(donation: false).sum(&:amount)
    if @not_yet_deposited < 0
      @not_yet_deposited = 0
    end
    @current_committee_expenses = @semester.expenses.where('date <= ?', Date.today).where("committee_id IS NOT NULL").all.sum(&:amount)
    @pending_deposits = @semester.deposits.where(posted: false).sum(:amount)
    @donation_deposit_amount = @semester.deposits.where(donation: true, posted: true).sum(:amount)
    @debt_deposit_amount = @semester.deposits.where(donation: false, posted: true).sum(:amount)
    @potential_revenue = @semester.debts.all.sum(&:amount)
    @spent_by_committees = 0
    @semester.expenses.all.each do |expense|
      if not expense.committee.nil?
        @spent_by_committees += expense.amount
      end
    end
    @appropriated = @semester.committees.all.sum(&:budget)
    @not_spent = @appropriated - @spent_by_committees

    # progress bar calculations
    @overdue_total = @semester.debts.where(status: false).where("due <= ?", Date.today).sum(:amount)
    @future_total = @semester.debts.where(status: false).where("due > ?", Date.today).sum(:amount)
    @payments_total = @semester.debts.where(status: true).sum(:amount)
    total = @semester.debts.sum(:amount).to_f
    @overdue_percent = (@overdue_total / total)*100
    @future_percent = (@future_total / total)*100
    @payment_percent = (@payments_total / total)*100

    c_current_balance = @deposits.sum(&:amount) - @current_expenses.sum(&:amount) + @pending_deposits
    date_hash = {}
    @future_expenses.each do |e|
      if date_hash.has_key?(e.date)
        date_hash[e.date] = date_hash[e.date] + e.amount
      else
        date_hash[e.date] = -e.amount
      end
    end
    @semester.debts.where(status: false).where("due > ?", Date.today).each do |f|
      if date_hash.has_key?(f.due)
        date_hash[f.due] = date_hash[f.due] + f.amount
      else
        date_hash[f.due] = f.amount
      end
    end
    date_hash = date_hash.sort_by{|k, _| k}
    dates = ['Now']
    balances = [c_current_balance.to_f]
    date_hash.each do |k, v|
      dates << k.to_s
      c_current_balance += v
      balances << c_current_balance.to_f
    end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Upcoming expenses and revenues")
      f.series(:name=> 'Balance', :yAxis => 0, :data => balances)
      f.xAxis [
        {:title => {:text => "Dates"}, :categories => dates}
      ]
      f.yAxis [
        {:title => {:text => "Balance"} },
      ]

      f.chart({:defaultSeriesType=>"line"})
    end
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.semester = current_user.chapter.get_current_semester
    if @expense.save
      redirect_to expenses_path, notice: "Expense created"
    else
      render action: 'new'
    end
  end

  def show
  end

  def toggle_reimbursed
    @expense.toggle!(:reimbursed)
    @expense.save
    redirect_to :back, :notice => "Reimbursement toggled"
  end

  def toggle_posted
    @expense.toggle!(:posted)
    @expense.save
    redirect_to :back, :notice => "Posted status toggled"
  end

  def not_reimbursed
    @expenses = @semester.expenses.where(reimbursed: false)
  end

  def not_posted
    @expenses = @semester.expenses.where(posted: false)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    def set_semester
      @semester = get_semester(current_user.chapter, params[:semester])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:date, :posted, :brother_id, :committee_id, :item, :reimbursed, :notes, :amount, :collection_id)
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
