class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
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
        @employee.level_id = nil if params[:show_level].to_i == 0
        @employee.group_ids = params[:group][:group_ids] if params[:group]
        format.html { redirect_to employees_path, notice: 'Сотрудник успешно добавлен.' }
        format.json { render action: 'show', status: :created, location: @employee }
      else
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
            @employee.update_attributes(:group_ids => params[:group][:group_ids], :level_id => nil) :
            @employee.update_attributes(:group_ids => params[:group][:group_ids])
        format.html { redirect_to @employee, notice: 'Сотудник успешно обновлен.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
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
      params.require(:employee).permit(:firstname, :middlename, :lastname, :snils, :level_id, :position_id, :user_id)
    end
end
