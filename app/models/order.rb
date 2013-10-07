# encoding: utf-8

class Order < ActiveRecord::Base
  belongs_to :employee
  belongs_to :client
  belongs_to :user
  belongs_to :city
  has_many :debts
  has_many :incomes
  validates_presence_of :ordernum, :orderdate, :startdate, :finishdate, :status, :ordersum, :employee, :user, :city_id

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

  def weight
    # months = Time.at((self.finishdate.to_date - 5) - self.startdate.to_date).month
    months = (self.finishdate.year * 12 + self.finishdate.month) - (self.startdate.year * 12 + self.startdate.month) + 1
    debtsum = self.ordersum / months
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
