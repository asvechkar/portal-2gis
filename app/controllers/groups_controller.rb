# encoding: utf-8

class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group_members = @group.employees
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = current_user.groups.new(group_params)

    respond_to do |format|
      if @group.save
        Tools.write2log(current_user.id, 'Добавление', 'Группы', 0, group_params.to_s)
        format.html { redirect_to groups_path, notice: 'Группа создана успешно.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Группы', 1, group_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        Tools.write2log(current_user.id, 'Обновление', 'Группы', 0, group_params.to_s)
        format.html { redirect_to @group, notice: 'Группа успешно обновлена.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Группы', 1, group_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Группы', 0, '# ' + @group.id.to_s)
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:code, :branch_id, :employee_id, :user_id)
    end
end
