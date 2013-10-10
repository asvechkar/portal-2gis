class PortalController < ApplicationController
  before_filter :authenticate_user!

  def index
    @branch = current_user.account_employee.branch
    # @branch = City.where(:name => 'Рязань').first.branches.first unless City.all.empty?
    unless @branch.nil?
      @total_clients_plan = 0
      @total_weight_plan = 0
      @total_incomes_plan = 0
      @total_ik_plan = 0
      @total_incomes_fact = Array.new
      @total_clients_fact = Array.new
      @total_weight_fact = Array.new
      @total_ik_fact = Array.new

      branch_clients_fact = 0
      branch_weight_fact = 0
      branch_incomes_fact = 0
      branch_prolong_percent = 0
      branch_debt = 0
      branch_con_clients_plan = 0

      days = Date.today.day
      @branch.groups.all.each unless @branch.nil? do |group|
        group.employees.all.each do |employee|
          branch_clients_fact += employee.get_new_fact_clients
          branch_weight_fact += employee.get_new_fact_weight
          branch_incomes_fact += employee.get_fact_incomes
          branch_debt += employee.get_installment_sum + employee.get_debt_sum
          branch_con_clients_plan += employee.get_cont_plan_clients
          @total_clients_plan += employee.get_new_plan_clients + employee.get_cont_plan_clients
          @total_weight_plan += employee.get_new_plan_weight + employee.get_cont_plan_weight
          @total_incomes_plan += ((employee.get_new_plan_weight + employee.get_cont_plan_weight) * 2.5) + employee.get_installment_sum + employee.get_debt_sum
        end
      end

      branch_prolong_percent += (branch_clients_fact.to_f / branch_con_clients_plan.to_f) * 100
      first = (branch_clients_fact.to_f / @total_clients_plan.to_f) * 0.2
      second = (branch_weight_fact.to_f / @total_weight_plan.to_f) * 0.3
      third = (branch_incomes_fact.to_f / ((@total_incomes_plan * 2.5) + branch_debt).to_f) * 0.3
      @total_ik_plan += first + second + third
      prolong = branch_prolong_percent.nan? ? 0 : branch_prolong_percent.round
      mult = Plancent.where("branch_id = #{@branch.id} AND year = #{Date.today.year} AND month = #{Date.today.month} AND fromprc <= '#{prolong}' AND toprc >= '#{prolong}'")
      if mult.empty?
        @total_ik_plan += 0
      else
        @total_ik_plan += mult.first.mult * 0.2
      end

      total_clients_fact_dif = 0
      total_incomes_fact_dif = 0
      total_weight_fact_dif = 0
      (1..days).each do |day|
        orderdate = Date.new(Date.today.year, Date.today.month, day)
        @branch.groups.all.each do |group|
          group.employees.all.each do |employee|
            total_clients_fact_dif += employee.get_fact_clients_by_date orderdate
            total_incomes_fact_dif += employee.get_incomes_by_date orderdate
            total_weight_fact_dif += employee.get_fact_weight_by_date orderdate
          end
        end
        @total_clients_fact << total_clients_fact_dif
        @total_incomes_fact << total_incomes_fact_dif
        @total_weight_fact << total_weight_fact_dif
      end
    end
  end

  def support
  end
end
