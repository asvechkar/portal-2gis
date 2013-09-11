class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all.page(params[:page]).per(25)
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = current_user.clients.new(client_params)

    respond_to do |format|
      if @client.save
        Tools.write2log(current_user.id, 'Добавление', 'Клиенты', 0, client_params.to_s)
        format.html { redirect_to clients_path, notice: 'Клиент был успешно добавлен.' }
        format.json { render action: 'show', status: :created, location: @client }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Клиенты', 1, client_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        Tools.write2log(current_user.id, 'Обновление', 'Клиенты', 0, client_params.to_s)
        format.html { redirect_to @client, notice: 'Клиент был успешно обновлен.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Клиенты', 1, city_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Клиенты', 0, '# ' + @client.id.to_s)
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:inn, :code, :name, :user_id)
    end
end
