class PortalController < ApplicationController
  before_filter :authenticate_user!

  def index
    @branch = City.where(:name => 'Рязань').first.branches.first
    @total_clients_plan = 0
    @total_weight_plan = 0
    @total_incomes_plan = 0
    @total_incomes_fact = Array.new
    @total_clients_fact = Array.new
    days = Date.today.day
    @branch.groups.all.each do |group|
      group.employees.all.each do |employee|
        @total_clients_plan += employee.get_new_plan_clients + employee.get_cont_plan_clients
        @total_weight_plan += employee.get_new_plan_weight + employee.get_cont_plan_weight
        @total_incomes_plan += ((employee.get_new_plan_weight + employee.get_cont_plan_weight) * 2.5) + employee.get_installment_sum + employee.get_debt_sum
      end
    end
    total_clients_fact_dif = 0
    total_incomes_fact_dif = 0
    (1..days).each do |day|
      orderdate = Date.new(Date.today.year, Date.today.month, day)
      @branch.groups.all.each do |group|
        group.employees.all.each do |employee|
          total_clients_fact_dif += employee.get_fact_clients_by_date orderdate
          total_incomes_fact_dif += employee.get_incomes_by_date orderdate
        end
      end
      @total_clients_fact << total_clients_fact_dif
      @total_incomes_fact << total_incomes_fact_dif
    end


  end
end
