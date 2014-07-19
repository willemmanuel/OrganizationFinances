class CommitteesController < ApplicationController
  include ApplicationHelper

  before_action :set_committee, only: [:show, :edit, :update, :destroy]
  before_action :set_semester, only: [:index]
  before_filter :require_chapter_manager

  # GET /committees
  # GET /committees.json
  def index
    @committees = @semester.committees.all
    @spent = 0
    @semester.committees.all.each do |committee|
      @spent += committee.expenses.sum(&:amount)
    end
    data = []
    @committees.each do |c|
      data << [c.name, c.budget.to_f]
    end
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Committee Budgets")
      f.series(:name=> 'Budget', :yAxis => 0, :data => data)
      f.plot_options(:pie => {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                }
            })
      f.chart({:defaultSeriesType=>"pie"},)
    end
  end

  # GET /committees/1
  # GET /committees/1.json
  def show
  end

  # GET /committees/new
  def new
    @committee = Committee.new
    @brothers = current_user.chapter.brothers.where(active: true).all
  end

  # GET /committees/1/edit
  def edit
    @brothers = current_user.chapter.brothers.where(active: true).all
  end

  # POST /committees
  # POST /committees.json
  def create
    @committee = Committee.new(committee_params)
    @committee.semester = current_user.chapter.get_current_semester
    respond_to do |format|
      if @committee.save
        format.html { redirect_to @committee, notice: 'Committee was successfully created.' }
        format.json { render action: 'show', status: :created, location: @committee }
      else
        format.html { render action: 'new' }
        format.json { render json: @committee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /committees/1
  # PATCH/PUT /committees/1.json
  def update
    respond_to do |format|
      if @committee.update(committee_params)
        format.html { redirect_to @committee, notice: 'Committee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @committee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /committees/1
  # DELETE /committees/1.json
  def destroy
    @committee.destroy
    respond_to do |format|
      format.html { redirect_to committees_url }
      format.json { head :no_content }
    end
  end

  private
    def set_semester
      @semester = get_semester(current_user.chapter, params[:semester])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_committee
      @committee = Committee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def committee_params
      params.require(:committee).permit(:name, :budget, :brother_id)
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
