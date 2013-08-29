class AveragebillsController < ApplicationController
  before_action :set_averagebill, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /averagebills
  # GET /averagebills.json
  def index
    @averagebills = Averagebill.all
  end

  # GET /averagebills/1
  # GET /averagebills/1.json
  def show
  end

  # GET /averagebills/new
  def new
    @averagebill = Averagebill.new
  end

  # GET /averagebills/1/edit
  def edit
  end

  # POST /averagebills
  # POST /averagebills.json
  def create
    @averagebill = current_user.averagebills.new(averagebill_params)

    respond_to do |format|
      if @averagebill.save
        format.html { redirect_to averagebills_path, notice: 'Средний чек успешно создан.' }
        format.json { render action: 'show', status: :created, location: @averagebill }
      else
        format.html { render action: 'new' }
        format.json { render json: @averagebill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /averagebills/1
  # PATCH/PUT /averagebills/1.json
  def update
    respond_to do |format|
      if @averagebill.update(averagebill_params)
        format.html { redirect_to averagebills_path, notice: 'Средний чек успешно обновлен.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @averagebill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /averagebills/1
  # DELETE /averagebills/1.json
  def destroy
    @averagebill.destroy
    respond_to do |format|
      format.html { redirect_to averagebills_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_averagebill
      @averagebill = Averagebill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def averagebill_params
      params.require(:averagebill).permit(:year, :month, :bill, :user_id, :branch_id)
    end
end
