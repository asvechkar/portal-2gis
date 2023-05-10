class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
  end

  def edit
  end

  def show
  end

  def create
    @role = Role.new(role_params)
    # @city.user_id = current_user.id

    respond_to do |format|
      if @role.save
        Tools.write2log(current_user.id, 'Добавление', 'Роли', 0, role_params.to_s)
        format.html { redirect_to roles_path, notice: 'Роль была успешно добавлена.' }
        format.json { render action: 'show', status: :created, location: @role }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Роли', 1, role_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @role.update(role_params)
        Tools.write2log(current_user.id, 'Обновление', 'Роли', 0, role_params.to_s)
        format.html { redirect_to roles_path, notice: 'Роль была успешно обновлена.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Роли', 1, role_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Роли', 0, '# ' + @role.id.to_s)
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :description, :user_id)
    end
end
