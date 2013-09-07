class LevelsController < ApplicationController
  before_action :set_level, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /levels
  # GET /levels.json
  def index
    @levels = Level.all
  end

  # GET /levels/1
  # GET /levels/1.json
  def show
  end

  # GET /levels/new
  def new
    @level = Level.new
  end

  # GET /levels/1/edit
  def edit
  end

  # POST /levels
  # POST /levels.json
  def create
    @level = current_user.levels.new(level_params)

    respond_to do |format|
      if @level.save
        Tools.write2log(current_user.id, 'Добавление', 'Уровни опыта', 0, level_params.to_s)
        format.html { redirect_to levels_path, notice: 'Level was successfully created.' }
        format.json { render action: 'show', status: :created, location: @level }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Уровни опыта', 1, level_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /levels/1
  # PATCH/PUT /levels/1.json
  def update
    respond_to do |format|
      if @level.update(level_params)
        Tools.write2log(current_user.id, 'Обновление', 'Уровни опыта', 0, level_params.to_s)
        format.html { redirect_to @level, notice: 'Level was successfully updated.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Уровни опыта', 1, level_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /levels/1
  # DELETE /levels/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Уровни опыта', 0, '# ' + @level.id.to_s)
    @level.destroy
    respond_to do |format|
      format.html { redirect_to levels_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_level
      @level = Level.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def level_params
      params.require(:level).permit(:name, :user_id)
    end
end
