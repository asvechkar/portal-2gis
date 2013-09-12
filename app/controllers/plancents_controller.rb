class PlancentsController < ApplicationController
  before_action :set_plancent, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /plancents
  # GET /plancents.json
  def index
    @plancents = Plancent.all
  end

  # GET /plancents/1
  # GET /plancents/1.json
  def show
  end

  # GET /plancents/new
  def new
    @plancent = Plancent.new
  end

  # GET /plancents/1/edit
  def edit
  end

  # POST /plancents
  # POST /plancents.json
  def create
    @plancent = current_user.plancents.new(plancent_params)

    respond_to do |format|
      if @plancent.save
        format.html { redirect_to plancents_path, notice: 'Plancent was successfully created.' }
        format.json { render action: 'show', status: :created, location: @plancent }
      else
        format.html { render action: 'new' }
        format.json { render json: @plancent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plancents/1
  # PATCH/PUT /plancents/1.json
  def update
    respond_to do |format|
      if @plancent.update(plancent_params)
        format.html { redirect_to plancents_path, notice: 'Plancent was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @plancent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plancents/1
  # DELETE /plancents/1.json
  def destroy
    @plancent.destroy
    respond_to do |format|
      format.html { redirect_to plancents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plancent
      @plancent = Plancent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plancent_params
      params.require(:plancent).permit(:year, :month, :branch_id, :fromprc, :toprc, :mult, :user_id)
    end
end
