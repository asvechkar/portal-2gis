class FactorsController < ApplicationController
  before_action :set_factor, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /factors
  # GET /factors.json
  def index
    branch = params[:filter_branch].present? ? params[:filter_branch] : current_employee.branch.id
    date = Date.strptime(params[:report_date], '%m.%Y') rescue Date.today
    @factors = Factor.where(branch_id: branch, month: date.month, year: date.year).order(:year, :month)
    if request.xhr?
      html = render_to_string(partial: 'factors', layout: false, locals: { factors: @factors })
      render json: { html: html }
    end
  end

  # GET /factors/1
  # GET /factors/1.json
  def show
  end

  # GET /factors/new
  def new
    @factor = current_user.factors.new
  end

  # GET /factors/1/edit
  def edit
  end

  # POST /factors
  # POST /factors.json
  def create
    @factor = current_user.factors.new(factor_params)
    date = Date.strptime(params[:report_date], '%m.%Y') rescue Date.today
    @factor.month = date.month
    @factor.year = date.year
    respond_to do |format|
      if @factor.save
        format.html { redirect_to @factor, notice: 'Factor was successfully created.' }
        format.json { render action: 'show', status: :created, location: @factor }
      else
        format.html { render action: 'new' }
        format.json { render json: @factor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /factors/1
  # PATCH/PUT /factors/1.json
  def update
    respond_to do |format|
      if @factor.update(factor_params)
        format.html { redirect_to @factor, notice: 'Factor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @factor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /factors/1
  # DELETE /factors/1.json
  def destroy
    @factor.destroy
    respond_to do |format|
      format.html { redirect_to factors_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_factor
      @factor = Factor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def factor_params
      params.require(:factor).permit(:branch_id, :month, :year, :prepay, :avaragebill, :clients, :weight, :incomes, :prolongcent, :proplancor, :planproc04from, :planproc04to, :planproc06from, :planproc06to, :planproc08from, :planproc08to, :planproc10from, :planproc10to, :planproc12from, :planproc12to)
    end
end
