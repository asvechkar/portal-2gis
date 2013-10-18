class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  # get 'employees/get_groups_by_branch_id/:id'
  def get_groups_by_branch_id
    select = '<option value="">Выберите группу</option>'
    begin
      branches = Branch.where(id: params[:id])
      unless branches.empty?
        groups = Group.where(branch_id: branches.first.id)
        groups.each do |group|
          select += "<option value='#{group.id}'>#{group.code}</option>"
        end
      end
    rescue Exception => e
      select = '<option value="">Групп нет</option>'
    end
    # render json: groups
    render text: select
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    if request.xhr?
      html = render_to_string(partial: 'employee', layout: false, locals: { employee: @employee })
      render json: { html: html }
    end
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = current_user.employees.new(employee_params)
    respond_to do |format|
      if @employee.save
        if params[:show_level].to_i == 0
          @employee.level_id = nil
          @employee.group_ids = nil
        end
        (@employee.group_ids = params[:group][:group_ids] if params[:group]) if params[:show_level].to_i != 0
        Tools.write2log(current_user.id, 'Добавление', 'Сотрудники', 0, employee_params.to_s)
        format.html { redirect_to employees_path, notice: 'Сотрудник успешно добавлен.' }
        format.json { render action: 'show', status: :created, location: @employee }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Сотрудники', 1, employee_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        (params[:show_level].to_i == 0) ?
            @employee.update_attributes(:group_ids => nil, :level_id => nil) :
            @employee.update_attributes(:group_ids => params[:group][:group_ids])
        Tools.write2log(current_user.id, 'Обновление', 'Сотрудники', 0, employee_params.to_s)
        format.html { redirect_to @employee, notice: 'Сотудник успешно обновлен.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Сотрудники', 1, employee_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Сотрудники', 0, '# ' + @employee.id.to_s)
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(
      :firstname,
      :middlename,
      :lastname,
      :snils,
      :level_id,
      :position_id,
      :branch_id,
      :user_id,
      :account_id,
      :birthdate,
      :gender,
      :about,
      :phone,
      :site,
      :facebook,
      :twitter,
      :skype,
      :vkontakte,
      :avatar)
    end
end
