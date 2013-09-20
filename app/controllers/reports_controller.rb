class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def planfact
    # @report_data = Employee.all.map{|employee| employee.groups.first.nil? ? nil : employee}.compact
    # @report_data = Employee.all.delete_if{|employee| employee.groups.first.nil?}

    @branch = if params[:id]
      Branch.find(params[:id])
    else
      nil
    end
  end
end
