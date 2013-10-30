class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def planfact
    params[:id].blank? ? @branch = current_user.branches.first : @branch = Branch.find(params[:id])
    if params[:report_date]
      date = Date.strptime(params[:report_date], '%m.%Y' )
      @planfact = @branch.planfacts.where(report_date: date).first
    end
  end

  def recalc_planfact
    date = params[:report_date].to_date rescue Date.today
    @branch = Branch.find(params[:branches_list]) rescue current_employee.branch
    if params[:update_planfact] == "1" && @branch
      @branch.groups.each do |group|
        group.employees.all.each do |employee|
          employee_planfact = {}
          employee_planfact[:report_date] = date
          employee_planfact[:clients_plan] = employee.plan_clients(date) # Клиенты план
          employee_planfact[:clients_fact] = employee.fact_clients(date) # Клиенты факт
          employee_planfact[:weight_plan] = employee.weight_new_clients(date) + employee.weight_cont_clients(date)
          employee_planfact[:weight_fact] = employee.fact_weight(date)# Груз факт
          employee_planfact[:income_plan] = employee.incomes_new_clients(date) + employee.incomes_cont_clients(date) # Поступления план
          employee_planfact[:income_fact] = employee.fact_incomes(date) # Поступления факт
          employee_planfact[:pro_percent] = employee.cont_percent(date) # % продления
          employee_planfact[:employee_ic] = employee.ik(date) # ИК
          employee.planfacts.find_or_create_by!(report_date: employee_planfact[:report_date]).update_attributes(employee_planfact)
        end
        #Группа
        group_planfact = {}
        group_planfact[:report_date] = date
        group_planfact[:clients_plan] = group.plan_clients(date)
        group_planfact[:clients_fact] = group.fact_clients(date)
        group_planfact[:weight_plan] = group.weight_new_clients(date) + group.weight_cont_clients(date)
        group_planfact[:weight_fact] = group.fact_weight(date)
        group_planfact[:income_plan] = group.incomes_new_clients(date) + group.incomes_cont_clients(date)
        group_planfact[:income_fact] = group.fact_incomes(date)
        group_planfact[:pro_percent] = group.cont_percent(date)
        group_planfact[:group_ic] = group.ik(date)
        group.planfacts.find_or_create_by!(report_date: group_planfact[:report_date]).update_attributes(group_planfact)
      end
      branch_planfact = {}
      branch_planfact[:report_date] = date
      branch_planfact[:clients_plan] = @branch.plan_clients(date)
      branch_planfact[:clients_fact] = @branch.fact_clients(date)
      branch_planfact[:weight_plan] =  @branch.weight_new_clients(date) + @branch.weight_cont_clients(date)
      branch_planfact[:weight_fact] =  @branch.fact_weight(date)
      branch_planfact[:income_plan] = @branch.incomes_new_clients(date) + @branch.incomes_cont_clients(date)
      branch_planfact[:income_fact] = @branch.fact_incomes(date)
      branch_planfact[:pro_percent] = @branch.cont_percent(date)
      branch_planfact[:branch_ic] = @branch.ik(date)
      @branch.planfacts.find_or_create_by!(report_date: branch_planfact[:report_date]).update_attributes(branch_planfact)
    end
    redirect_to action: :planfact, id: @branch.id, report_date: date.strftime("%m.%Y")
  end

end
