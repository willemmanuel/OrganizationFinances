require 'stripe'
class DebtsController < ApplicationController

  include ApplicationHelper

  before_action :set_debt, only: [:show, :edit, :update, :destroy, :toggle_paid, :new_payment, :create_payment]
  before_action :set_semester
  before_filter :require_chapter_manager, except: [:new_payment, :create_payment]

  # GET /debts
  # GET /debts.json
  def index
    @debts = @semester.debts.where(status: false).all

    @overdue_total = @semester.debts.where(status: false).where("due <= ?", Date.today).sum(:amount)
    @future_total = @semester.debts.where(status: false).where("due > ?", Date.today).sum(:amount)
    @payments_total = @semester.debts.where(status: true).sum(:amount)

    @payments = @semester.debts.where(status: true).paginate(:per_page => 10, :page => params[:payment_page])
    @overdue = @semester.debts.where(status: false).where("due <= ?", Date.today).paginate(:per_page => 10, :page => params[:overdue_page])
    @future = @semester.debts.where(status: false).where("due > ?", Date.today).paginate(:per_page => 10, :page => params[:future_page])

    total = @semester.debts.sum(:amount).to_f
    @overdue_percent = (@overdue_total / total)*100
    @future_percent = (@future_total / total)*100
    @payment_percent = (@payments_total / total)*100
  end

  # GET /debts/1
  # GET /debts/1.json
  def show
    redirect_to edit_debt_path(@debt)
  end

  # GET /debts/new
  def new
    @brothers = current_user.chapter.brothers.where(active: true).all
    @collections = current_user.chapter.get_current_semester.collections.all
    @debt = Debt.new
    @debt.semester = @semester
  end

  # GET /debts/1/edit
  def edit
    @brothers = current_user.chapter.brothers.where(active: true).all
    @collections = current_user.chapter.get_current_semester.collections.all
  end

  # POST /debts
  # POST /debts.json
  def create
    @debt = Debt.new(debt_params)
    if (@debt.semester == nil)
      @debt.semester = @semester
    end
    if params[:debt][:brother_id].kind_of?(Array) && params[:debt][:brother_id].count > 1
      params[:debt][:brother_id].each do |bid|
        next if bid.blank?
        d = Debt.new(debt_params)
        d.brother_id = bid
        d.semester = @debt.semester
        d.save
      end
      redirect_to debts_path, notice: 'Debts were successfully created.'
      return
    end
    if params[:debt][:brother_id].include? ''
      current_user.chapter.brothers.where(active: true).all.each do |b|
        d = Debt.new(debt_params)
        d.brother_id = b.id
        d.semester = @debt.semester
        d.save
      end
      redirect_to debts_path, notice: 'Debts were successfully created.'
      return
    end
    respond_to do |format|
      if @debt.save
        format.html { redirect_to debts_path, notice: 'Debt was successfully created.' }
        format.json { render action: 'show', status: :created, location: @debt }
      else
        format.html { render action: 'new' }
        format.json { render json: @debt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /debts/1
  # PATCH/PUT /debts/1.json
  def update
    respond_to do |format|
      if @debt.update(debt_params)
        format.html { redirect_to debts_path, notice: 'Debt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @debt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debts/1
  # DELETE /debts/1.json
  def destroy
    @debt.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: "Debt destroyed" }
      format.json { head :no_content }
    end
  end

  def new_payment
  end

  def create_payment
    self.toggle_paid
    charge = Stripe::Charge.create(
      :amount      =>  @debt.stripe_amount.to_i,
      :card        => params[:stripeToken],
      :description => 'Payment from ' + @debt.brother.name + ' for ' + @debt.name,
      :currency    => 'usd'
    )
    rescue Stripe::CardError => e
      self.toggle_paid
      flash[:error] = e.message
      redirect_to new_payment_path(@debt)
  end

  def toggle_paid
    @debt.toggle!(:status)
    if @debt.status
      @debt.paid = Date.today
    else
      @debt.paid = nil
    end
    @debt.save
    redirect_to :back, :notice => "Debt status changed"
  end

  private
    def set_semester
      @semester = get_semester(current_user.chapter, params[:semester])
    end

    def set_debt
      @debt = Debt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def debt_params
      params.require(:debt).permit(:name, :brother_id, :amount, :status, :due, :paid, :notes, :stripeToken, :collection_id)
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
