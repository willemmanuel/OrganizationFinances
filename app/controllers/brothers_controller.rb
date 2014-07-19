require 'twilio-ruby'

class BrothersController < ApplicationController
  SID = ''
  TOKEN = ''
  CLIENT = Twilio::REST::Client.new SID, TOKEN

  before_action :set_brother, only: [:show, :edit, :update, :destroy, :overdue_email_nag, :future_email_nag, :text_nag, :add_demerit, :remove_demerit, :pay_off_demerit, :make_manager, :toggle_active]
  skip_before_filter :verify_authenticity_token, :only => :search
  before_filter :require_chapter_manager, except: :personal

  def personal
    @brother = current_user.brother
    @debts = Debt.where(brother_id: @brother.id, status: false).all
    @payments = Debt.where(brother_id: @brother.id, status: true).all
    @overdue_total = Debt.where(brother_id: @brother.id, status: false).where("due <= ?", Date.today).sum(:amount)
    @future_total = Debt.where(brother_id: @brother.id, status: false).where("due > ?", Date.today).sum(:amount)
    @payments_total = Debt.where(brother_id: @brother.id, status: true).sum(:amount)
    @overdue = Debt.where(brother_id: @brother.id, status: false).where("due <= ?", Date.today).all
    @future = Debt.where(brother_id: @brother.id, status: false).where("due > ?", Date.today).all
    @present = Attendance.where(brother: @brother, status: "present")
    @excused = Attendance.where(brother: @brother, status: "excused")
    @unexcused = Attendance.where(brother: @brother, status: "unexcused")
    @justified = Attendance.where(brother: @brother, status: "justified")
  end

  # GET /brothers
  # GET /brothers.json
  def index
    if (params[:status] == 'inactive')
      @inactive_list = true
      @brothers = current_user.chapter.brothers.where(active: false).all
    else
      @inactive_list = false
      @brothers = current_user.chapter.brothers.where(active: true).all
    end
    @pledge = current_user.chapter.brothers.where(active: true).where(year: 1).all
    @second = current_user.chapter.brothers.where(active: true).where(year: 2).all
    @third = current_user.chapter.brothers.where(active: true).where(year: 3).all
    @forth = current_user.chapter.brothers.where(active: true).where(year: 4).all
    @bad_standing = current_user.chapter.brothers.where('id IN (?) OR id IN (?)', current_user.chapter.brothers.where("demerit > 2.9").pluck(:id), current_user.chapter.brothers.joins(:debts).where("due <= ?", Date.today).pluck(:id)).all
  end

  # GET /brothers/1
  # GET /brothers/1.json
  def show
    @debts = Debt.where(brother_id: @brother.id, status: false).all
    @payments = Debt.where(brother_id: @brother.id, status: true).all
    @overdue_total = Debt.where(brother_id: @brother.id, status: false).where("due <= ?", Date.today).sum(:amount)
    @future_total = Debt.where(brother_id: @brother.id, status: false).where("due > ?", Date.today).sum(:amount)
    @payments_total = Debt.where(brother_id: @brother.id, status: true).sum(:amount)
    @overdue = Debt.where(brother_id: @brother.id, status: false).where("due <= ?", Date.today).all
    @future = Debt.where(brother_id: @brother.id, status: false).where("due > ?", Date.today).all
    @present = Attendance.where(brother: @brother, status: "present")
    @excused = Attendance.where(brother: @brother, status: "excused")
    @unexcused = Attendance.where(brother: @brother, status: "unexcused")
    @justified = Attendance.where(brother: @brother, status: "justified")
  end

  # GET /brothers/new
  def new
    @brother = Brother.new
  end

  def bulk_create
    if params[:csv].nil?
      return
    end
    errors = Array.new
    params[:csv].split(/\n/).each do |row|
      data = row.split(',')
      brother = Brother.new
      brother.name = data[0].to_s
      brother.phone = data[1].to_s
      brother.email = data[2].to_s
      brother.year = data[3].to_s
      brother.demerit = 0
      brother.chapter = current_user.chapter
      brother.active = true
      brother.save
      if brother.errors.any?
        errors << brother.name
      end
    end
    if errors.empty?
      redirect_to :back, notice: "Brothers created"
    else
      redirect_to :back, notice: "Error creating: " + errors.to_s
    end
  end

  # GET /brothers/1/edit
  def edit
  end

  def toggle_active
    @brother.active = !(@brother.active)
    @brother.save
    redirect_to :back, notice: "Brother status toggled"
  end

  def add_demerit
    @brother.demerit += (1.0/3.0)
    @brother.save
    redirect_to :back, notice: "Demerit added"
  end
  def remove_demerit
    @brother.demerit -= (1.0/3.0)
    @brother.save
    redirect_to :back, notice: "Demerit removed"
  end
  def pay_off_demerit
    if @brother.demerit < 2.9
      redirect_to :back, notice: "Brother has less than three demerits"
      return
    end
    amount = 50 + ((@brother.demerit - 3) * 10)
    @demerit_debt = Debt.new(brother: @brother, name:"Demerit reduction", due: Date.today, amount:amount, status: false)
    @demerit_debt.save
    @brother.demerit = 0
    @brother.save
    redirect_to :back, notice: "Demerit debt created"
  end

  # POST /brothers
  # POST /brothers.json
  def create
    @brother = Brother.new(brother_params)
    @brother.demerit = 0
    @brother.chapter = current_user.chapter
    @brother.active = true
    respond_to do |format|
      if @brother.save
        format.html { redirect_to @brother, notice: 'Brother was successfully created.' }
        format.json { render action: 'show', status: :created, location: @brother }
      else
        format.html { render action: 'new' }
        format.json { render json: @brother.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brothers/1
  # PATCH/PUT /brothers/1.json
  def update
    respond_to do |format|
      if @brother.update(brother_params)
        format.html { redirect_to @brother, notice: 'Brother was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @brother.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brothers/1
  # DELETE /brothers/1.json
  def destroy
    @brother.destroy
    respond_to do |format|
      format.html { redirect_to brothers_path }
      format.json { head :no_content }
    end
  end

  def overdue_email_nag
    @debts = Debt.where(brother_id: @brother.id, status: false).where("due <= ?", Date.today).all
    if @debts.empty?
      redirect_to :back, :notice => "No debts to nag about!"
      return
    end
    BrotherMailer.overdue_email(@brother, @debts).deliver
    redirect_to :back, :notice => "Email sent"
  end

  def overdue_email_nag_all
    brothers = current_user.chapter.brothers.all
    brothers.each do |b|
      debts = Debt.where(brother_id: b.id, status: false).where("due <= ?", Date.today).all
      if !debts.empty?
        BrotherMailer.overdue_email(b, debts).deliver
      end
    end
    redirect_to :back, :notice => "Emails sent"
  end

  def future_email_nag
    @debts = Debt.where(brother_id: @brother.id, status: false).where("due > ?", Date.today).all
    if @debts.empty?
      redirect_to :back, :notice => "No debts to nag about!"
      return
    end
    BrotherMailer.future_email(@brother, @debts).deliver
    redirect_to :back, :notice => "Email sent"
  end

  def future_email_nag_all
    brothers = current_user.chapter.brothers.all
    brothers.each do |b|
      debts = Debt.where(brother_id: b.id, status: false).where("due > ?", Date.today).all
      if !debts.empty?
        BrotherMailer.future_email(b, debts).deliver
      end
    end
    redirect_to :back, :notice => "Emails sent"
  end

  def text_nag
    debts = Debt.where(brother_id: @brother.id, status: false).where("due <= ?", Date.today).all
    if debts.empty?
      redirect_to :back, :notice => "No debts to nag about!"
      return
    end
    total = 0
    debts.each do |d|
      total += d.amount
    end
    total = total.to_i
    message = CLIENT.account.messages.create(:body => "This is an automated reminder from Will, you owe $" + total.to_s + " to the house. These payments are overdue, bring a check ASAP",
      :to => @brother.phone,
      :from => "+18136993468")
    redirect_to :back, :notice => "Text sent"
  end

  def text_nag_all
    brothers = current_user.chapter.brothers.all
    brothers.each do |b|
      debts = Debt.where(brother_id: b.id, status: false).where("due <= ?", Date.today).all
      if debts.empty?
        next
      end
      total = 0
      debts.each do |d|
        total += d.amount
      end
      total = total.to_i
      message = CLIENT.account.messages.create(:body => "This is reminder from Will, you owe $" + total.to_s + " to the house. These payments are overdue, bring a check ASAP",
        :to => b.phone,
        :from => "+18136993468")
    end
    redirect_to :back, :notice => "Texts sent"
  end

  def search
    if Rails.env.production?
      @brothers = Brother.find(:all, conditions: ['name ILIKE ?', "%#{params[:search]}%"])
    else
      @brothers = Brother.find(:all, conditions: ['name LIKE ?', "%#{params[:search]}%"])
    end
    @search = params[:search]
    if @brothers.count == 1
      redirect_to @brothers.first
    end
  end

  def make_manager
    @brother.user.toggle!(:chapter_manager)
    @brother.save
    redirect_to :back, :notice => "Brother status changed"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brother
      @brother = Brother.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brother_params
      params.require(:brother).permit(:name, :phone, :email, :year, :search)
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
