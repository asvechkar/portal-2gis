class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /incomes
  # GET /incomes.json
  def index
    @incomes = Income.all
  end

  # GET /incomes/1
  # GET /incomes/1.json
  def show
  end

  # GET /incomes/new
  def new
    @income = Income.new
  end

  # GET /incomes/1/edit
  def edit
  end

  # POST /incomes
  # POST /incomes.json
  def create
    @income = current_user.incomes.new(income_params)

    respond_to do |format|
      if @income.save
        Tools.write2log(current_user.id, 'Добавление', 'Поступления', 0, income_params.to_s)
        format.html { redirect_to incomes_path, notice: 'Поступление успешно добавлено.' }
        format.json { render action: 'show', status: :created, location: @income }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Поступления', 1, income_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incomes/1
  # PATCH/PUT /incomes/1.json
  def update
    respond_to do |format|
      if @income.update(income_params)
        Tools.write2log(current_user.id, 'Обновление', 'Поступления', 0, income_params.to_s)
        format.html { redirect_to incomes_path, notice: 'Поступление успешно обновлено.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Поступления', 1, income_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incomes/1
  # DELETE /incomes/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Поступления', 0, '# ' + @income.id.to_s)
    @income.destroy
    respond_to do |format|
      format.html { redirect_to incomes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income
      @income = Income.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_params
      params.require(:income).permit(:indate, :client_id, :insum, :employee_id, :cash, :order_id, :user_id)
    end
end
