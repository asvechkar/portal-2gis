class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def planfact
    @report_data = Employee.all.map{|employee| employee.groups.first.nil? ? nil : employee}.compact
  end
end
