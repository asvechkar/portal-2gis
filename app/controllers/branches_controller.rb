class BranchesController < ApplicationController
  before_action :set_branch, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /branches
  # GET /branches.json
  def index
    @branches = Branch.all
  end

  # GET /branches/1
  # GET /branches/1.json
  def show
  end

  def groups_list
    res = {}
    @branch.groups.each { |g| res[g.id] = g.code }
    render json: { groups: res }
  end

  def employees_list
    res = {}
    @branch.employees.each { |e| res[e.id] = e.initials }
    render json: { employees: res }
  end

  # GET /branches/new
  def new
    @branch = Branch.new
  end

  # GET /branches/1/edit
  def edit
  end

  # POST /branches
  # POST /branches.json
  def create
    @branch = current_user.branches.new(branch_params)

    respond_to do |format|
      if @branch.save
        Tools.write2log(current_user.id, 'Добавление', 'Филиалы', 0, branch_params.to_s)
        format.html { redirect_to branches_path, notice: 'Филиал был успешно добавлен.' }
        format.json { render action: 'show', status: :created, location: @branch }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Филиалы', 1, branch_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /branches/1
  # PATCH/PUT /branches/1.json
  def update
    respond_to do |format|
      if @branch.update(branch_params)
        Tools.write2log(current_user.id, 'Обновление', 'Филиалы', 0, branch_params.to_s)
        format.html { redirect_to @branch, notice: 'Филиал был успешно обновлен.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Филиалы', 1, branch_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Филиалы', 0, '# ' + @branch.id.to_s)
    @branch.destroy
    respond_to do |format|
      format.html { redirect_to branches_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = Branch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def branch_params
      params.require(:branch).permit(:name, :city_id, :employee_id, :user_id)
    end
end
