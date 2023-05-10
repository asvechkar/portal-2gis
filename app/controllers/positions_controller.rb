class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.all
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
  end

  def level
    @level = Position.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /positions
  # POST /positions.json
  def create
    @position = current_user.positions.new(position_params)

    respond_to do |format|
      if @position.save
        Tools.write2log(current_user.id, 'Добавление', 'Должности', 0, position_params.to_s)
        format.html { redirect_to positions_path, notice: 'Position was successfully created.' }
        format.json { render action: 'show', status: :created, location: @position }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Должности', 1, position_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
  def update
    respond_to do |format|
      if @position.update(position_params)
        Tools.write2log(current_user.id, 'Обновление', 'Должности', 0, position_params.to_s)
        format.html { redirect_to @position, notice: 'Position was successfully updated.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Должности', 1, position_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Должности', 0, '# ' + @position.id.to_s)
    @position.destroy
    respond_to do |format|
      format.html { redirect_to positions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(:name, :user_id, :show_experience_level)
    end
end
