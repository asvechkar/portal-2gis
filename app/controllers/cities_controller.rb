class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end

  # GET /cities/new
  def new
    @city = City.new
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = current_user.cities.new(city_params)
    # @city.user_id = current_user.id

    respond_to do |format|
      if @city.save
        Tools.write2log(current_user.id, 'Добавление', 'Города', 0, city_params.to_s)
        format.html { redirect_to cities_path, notice: 'Город был успешно добавлен.' }
        format.json { render action: 'show', status: :created, location: @city }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Города', 0, city_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        Tools.write2log(current_user.id, 'Обновление', 'Города', 0, city_params.to_s)
        format.html { redirect_to cities_path, notice: 'Город был успешно обновлен.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Города', 0, city_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Города', 0, '# ' + @city.id.to_s)
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :user_id)
    end
end
