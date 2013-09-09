class PortalController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def get_incomes_by_month
    result = ''
    begin
      date = DateTime.new(DateTime.now.year, params[:month].to_i, 7, 0, 0, 0, 0)
      firstDay = date.at_beginning_of_month
      lastDay = date.at_end_of_month
      result = '['
      employees = Employee.all
      totaldelim = ''
      employees.each do |employee|
        incomes = Income.select('SUM(insum) as totalsum, employee_id, indate').where("indate BETWEEN '#{firstDay}' AND '#{lastDay}' AND employee_id = #{employee.id}").group('employee_id, indate')
        unless incomes.empty?
          result += totaldelim + '{'
          result += 'label: "' + employee.initials + '",'
          result += 'data: ['
          delimeter = ''
          incomes.each do |income|
            result += delimeter + '["' + income.indate.strftime('%d.%m') + '",' + sprintf( "%0.02f", income.totalsum) + ']'
            delimeter = ','
          end
          result += ']'
          result += '}'
          totaldelim = ','
        end
      end
      result += ']'
    rescue Exception => e
      result = e.to_s
    end
    render json: result
  end
end
