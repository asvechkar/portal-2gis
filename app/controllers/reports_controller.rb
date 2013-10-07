class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def planfact
    # @report_data = Employee.all.map{|employee| employee.groups.first.nil? ? nil : employee}.compact
    # @report_data = Employee.all.delete_if{|employee| employee.groups.first.nil?}

    @branches_sel = Branch.where(id: current_user.get_branches).order('name ASC')

    @branch = if params[:id]
      Branch.find(params[:id])
    else
      nil
    end
  end
end
