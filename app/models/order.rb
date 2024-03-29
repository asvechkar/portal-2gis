# encoding: utf-8

class Order < ApplicationRecord
  belongs_to :employee
  belongs_to :client
  belongs_to :user
  belongs_to :city
  has_many :debts
  has_many :incomes
  validates_presence_of :ordernum, :orderdate, :startdate, :finishdate, :status, :ordersum, :employee, :user, :city_id

  scope :today, ->(user_id) { where('user_id = ? and created_at between ? and ?',
                                    user_id,
                                    DateTime.now.beginning_of_day,
                                    DateTime.now.end_of_day) }
  scope :current, -> { where("finishdate > '#{Date.today.at_end_of_month}'") }
  scope :continue, -> { where("finishdate = '#{Date.today.at_end_of_month}'") }
  scope :by_branch, ->(branch) { joins(:employee).where('employees.branch_id = ?', branch) if branch.present? }
  scope :by_ordernum, ->(ordernum) { where(ordernum: ordernum) if ordernum.present? }
  scope :by_employee, ->(employee) { where(employee_id: employee) if employee.present? }

  def status_desc
    case self.status
      when 0 then 'Открыт'
      when 1 then 'Закрыт'
      when 2 then 'Отказ'
      else 'Аннулирован'
    end
  end

  def continue_desc
    case self.continue
      when 0 then 'нет'
      when 1 then 'да'
      else 'нет'
    end
  end

  def set_continue
    self.continue = true
  end

  def weight
    # months = Time.at((self.finishdate.to_date - 5) - self.startdate.to_date).month
    months = (self.finishdate.year * 12 + self.finishdate.month) - (self.startdate.year * 12 + self.startdate.month) + 1
    debtsum = self.ordersum / months rescue 0
    return debtsum
  end

  def floating_debt(uid)
    count = 0
    # months = Time.at(self.finishdate - self.startdate).month # + 1
    months = (self.finishdate.year * 12 + self.finishdate.month) - (self.startdate.year * 12 + self.startdate.month) + 1
    now = self.startdate
    debtsum = self.ordersum / months
    months.times {
      present_debt = Debt.where(:year => now.year,
                                :month => now.month,
                                :debtsum => debtsum,
                                :employee_id => self.employee_id,
                                :client_id => self.client_id,
                                :order_id => self.id).first
      new_debt = Debt.create(:year => now.year,
                  :month => now.month,
                  :debtsum => debtsum,
                  :employee_id => self.employee_id,
                  :client_id => self.client_id,
                  :order_id => self.id,
                  :debttype => 0,
                  :user_id => uid) unless present_debt
      now = now + 1.month
      count += 1 if new_debt
    }
    'Рассчитано ' + count.to_s + ' текущих задолженностей по БЗ ' + self.ordernum + '<br>'
  end
end
