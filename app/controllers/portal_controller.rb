class PortalController < ApplicationController
  before_filter :authenticate_user!

  def index
    @branch = City.where(:name => 'Рязань').first.branches.first
    @total_clients_plan = 0
    @total_clients_fact = Array.new
    days = Date.today.day
    @branch.groups.all.each do |group|
      group.employees.all.each do |employee|
        @total_clients_plan += employee.get_new_plan_clients + employee.get_cont_plan_clients
      end
    end
    total_clients_fact_dif = 0
    (1..days).each do |day|
      orderdate = Date.new(Date.today.year, Date.today.month, day)
      @branch.groups.all.each do |group|
        group.employees.all.each do |employee|
          total_clients_fact_dif += employee.get_fact_clients_by_date orderdate
        end
      end
      @total_clients_fact << total_clients_fact_dif
    end
  end
end
