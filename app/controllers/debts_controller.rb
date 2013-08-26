class DebtsController < ApplicationController
  before_action :set_debt, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /debts
  # GET /debts.json
  def index
    @debts = Debt.all
  end

  # GET /debts/1
  # GET /debts/1.json
  def show
  end

  # GET /debts/new
  def new
    @debt = Debt.new
  end

  # GET /debts/1/edit
  def edit
  end

  # POST /debts
  # POST /debts.json
  def create
    @debt = current_user.debts.new(debt_params)

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
        format.html { redirect_to @debt, notice: 'Debt was successfully updated.' }
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
      format.html { redirect_to debts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debt
      @debt = Debt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def debt_params
      params.require(:debt).permit(:year, :month, :employee_id, :client_id, :order_id, :debtsum, :debttype, :user_id)
    end
end
