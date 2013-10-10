class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def planfact
    # @report_data = Employee.all.map{|employee| employee.groups.first.nil? ? nil : employee}.compact
    # @report_data = Employee.all.delete_if{|employee| employee.groups.first.nil?}
    @branch = Branch.find(params[:id]) if params[:id]
  end

  def recalc_planfact
    date = params[:report_date].to_date
    params[:id].blank? ? @branch = current_user.branches.first : @branch = Branch.find(params[:id])
    if @branch
      branch_debt = 0
      branch_clients_plan = 0
      branch_clients_fact = 0
      branch_weight_plan = 0
      branch_weight_fact = 0
      branch_incomes_plan = 0
      branch_incomes_fact = 0
      branch_prolong_percent = 0
      branch_ic = 0
      @branch.groups.each do |group|
        group_clients_plan = 0
        group_con_clients_plan = 0
        group_clients_fact = 0
        group_weight_plan = 0
        group_weight_fact = 0
        group_incomes_plan = 0
        group_incomes_fact = 0
        group_prolong_percent = 0
        group_debt = 0
        group_ic = 0
        group_planfact = {}
        group.employees.all.each do |employee|
          unless employee.planfacts.find_by(report_date: params[:report_date])
            employee_planfact = {}
            employee_planfact[:report_date] = params[:report_date]
            clients_plan = employee.get_new_plan_clients_by_date(date) + employee.get_cont_plan_clients_by_date(date) # Клиенты план
            employee_planfact[:clients_plan] = clients_plan
            group_clients_plan += clients_plan
            group_con_clients_plan += employee.get_cont_plan_clients_by_date(date)
            clients_fact = employee.get_new_fact_clients_by_date(date) # Клиенты факт
            employee_planfact[:clients_fact] = clients_fact
            group_clients_fact += clients_fact
            weight_plan = employee.get_new_plan_weight_by_date(date) + employee.get_cont_plan_weight_by_date(date)
            employee_planfact[:weight_plan] = weight_plan
            group_weight_plan += weight_plan
            weight_fact = employee.get_new_fact_weight_by_date(date)# Груз факт
            employee_planfact[:weight_fact] = weight_fact
            group_weight_fact += weight_fact
            income_plan = ((employee.get_new_plan_weight_by_date(date) + employee.get_cont_plan_weight_by_date(date)) * 2.5) + employee.get_installment_sum_by_date(date) + employee.get_debt_sum_by_date(date) # Поступления план
            employee_planfact[:income_plan] = income_plan
            group_incomes_plan += income_plan
            income_fact = employee.get_fact_incomes_by_date(date) # Поступления факт
            employee_planfact[:income_fact] = income_fact
            group_incomes_fact += income_fact
            group_debt += employee.get_installment_sum_by_date(date) + employee.get_debt_sum_by_date(date)
            branch_debt += group_debt
            employee_planfact[:pro_percent] = employee.get_prolong_percents_by_date(date) # % продления
            employee_planfact[:employee_ic] = employee.get_ic_by_date(date) # ИК
            employee.planfacts.create!(employee_planfact)
          end
        end
        #Группа
        unless group.planfacts.find_by(report_date: params[:report_date])
          group_planfact[:report_date] = params[:report_date]
          group_planfact[:clients_plan] = group_clients_plan
          branch_clients_plan += group_clients_plan
          group_planfact[:clients_fact] = group_clients_fact
          branch_clients_fact += group_clients_fact
          group_planfact[:weight_plan] = group_weight_plan
          branch_weight_plan += group_weight_plan
          group_planfact[:weight_fact] = group_weight_fact
          branch_weight_fact += group_weight_fact
          group_planfact[:income_plan] = group_incomes_plan
          branch_incomes_plan += group_incomes_plan
          group_planfact[:income_fact] = group_incomes_fact
          branch_incomes_fact += group_incomes_fact
          group_prolong_percent = (group_clients_fact.to_f / group_con_clients_plan.to_f) * 100
          group_planfact[:pro_percent] = group_prolong_percent.nan? ? 0 : group_prolong_percent.to_i
          branch_prolong_percent += group_prolong_percent
          # Расчет группового ИК
          first = (group_clients_fact.to_f / group_clients_plan.to_f) * 0.2
          second = (group_weight_fact.to_f / group_weight_plan.to_f) * 0.3
          third = (group_incomes_fact.to_f / ((group_weight_plan * 2.5) + group_debt).to_f) * 0.3
          group_ic += first + second + third
          prolong = group_prolong_percent.nan? ? 0 : group_prolong_percent.round
          mult = Plancent.where("branch_id = #{group.branch_id} AND year = #{date.year} AND month = #{date.month} AND fromprc <= '#{prolong}' AND toprc >= '#{prolong}'")
          mult.empty? ? group_ic += 0  : group_ic += mult.first.mult * 0.2
          group_planfact[:group_ic] = group_ic
          group.planfacts.create!(group_planfact)
        end
      end
      unless @branch.planfacts.find_by(report_date: params[:report_date])
        branch_planfact = {}
        branch_planfact[:report_date] = params[:report_date]
        branch_planfact[:clients_plan] = branch_clients_plan
        branch_planfact[:clients_fact] = branch_clients_fact
        branch_planfact[:weight_plan] = branch_weight_plan
        branch_planfact[:weight_fact] = branch_weight_fact
        branch_planfact[:income_plan] = branch_incomes_plan
        branch_planfact[:income_fact] = branch_incomes_fact
        branch_planfact[:pro_percent] = (!branch_prolong_percent.is_a?(Fixnum) && branch_prolong_percent.nan?) ? 0 : branch_prolong_percent.round
        #Расчет филиального ИК
        first = (branch_clients_fact.to_f / branch_clients_plan.to_f) * 0.2
        second = (branch_weight_fact.to_f / branch_weight_plan.to_f) * 0.3
        third = (branch_incomes_fact.to_f / ((branch_weight_plan * 2.5) + branch_debt).to_f) * 0.3
        branch_ic += first + second + third
        prolong = (!branch_prolong_percent.is_a?(Fixnum) && branch_prolong_percent.nan?) ? 0 : branch_prolong_percent.round
        mult = Plancent.where("branch_id = #{@branch.id} AND year = #{date.year} AND month = #{date.month} AND fromprc <= '#{prolong}' AND toprc >= '#{prolong}'")
        mult.empty? ? branch_ic += 0 : branch_ic += mult.first.mult * 0.2
        branch_planfact[:branch_ic] = branch_ic
        @branch.planfacts.create!(branch_planfact)
      end
    end
    redirect_to action: :planfact, id: @branch.id, report_date: date.strftime("%d.%m.%Y")
  end

end
