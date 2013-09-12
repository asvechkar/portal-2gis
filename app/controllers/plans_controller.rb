class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.all
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = current_user.plans.new(plan_params)

    respond_to do |format|
      if @plan.save
        Tools.write2log(current_user.id, 'Добавление', 'Планы', 0, plan_params.to_s)
        format.html { redirect_to plans_path, notice: 'План был успешно добавлен.' }
        format.json { render action: 'show', status: :created, location: @plan }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Планы', 1, plan_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    respond_to do |format|
      if @plan.update(plan_params)
        Tools.write2log(current_user.id, 'Обновление', 'Планы', 0, plan_params.to_s)
        format.html { redirect_to plans_path, notice: 'План был успешно обновлен.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Планы', 1, plan_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Планы', 0, '# ' + @plan.id.to_s)
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to plans_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:year, :month, :clients, :weight, :total, :employee_id, :user_id)
    end
end
