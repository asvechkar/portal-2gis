class PortalController < ApplicationController
  before_filter :authenticate_user!

  def index
    a = Array.new
    @theend = Hash.new
    firstDay = Date.today.at_beginning_of_month
    lastDay = Date.today.at_end_of_month
    #@allincomes = Income.all
    #@alldates = Income.select('indate').where("indate BETWEEN '#{firstDay}' AND '#{lastDay}'").order(:indate).uniq
    incomes = Income.select('SUM(insum) as totalsum, employee_id, indate').where("indate BETWEEN '#{firstDay}' AND '#{lastDay}'").group('employee_id, indate').order(:indate)
    # TODO: вместо запросов сделать сортировки массива incomes
    employees = Income.select('employee_id').uniq
    indates = Income.select('indate').where("indate BETWEEN '#{firstDay}' AND '#{lastDay}'").order(:indate).uniq
    b = Array.new
    fio = Array.new
    indates.each do |indate|
      h = Hash.new
      h[:indate] = indate.indate.strftime('%d.%m.%Y')
      employees.each do |emp|
        # TODO: one-  query
        if incomes.where(employee_id: emp.employee_id, indate: indate.indate).first
          h['e' + emp.employee_id.to_s] = incomes.where(employee_id: emp.employee_id, indate: indate.indate).first.totalsum
        #else
        #  h['e' + emp.employee_id.to_s] = 0
        end
        b << 'e' + emp.employee_id.to_s
        fio << Employee.find(emp.employee_id).initials
      end
      a << h
    end
    @theend['data'] = a
    @theend['labels'] = b.uniq
    @theend['initials'] = fio.uniq
  end
end
