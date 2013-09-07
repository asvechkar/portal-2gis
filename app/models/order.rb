class Order < ActiveRecord::Base
  belongs_to :employee
  belongs_to :client
  belongs_to :user
  has_many :debts
  has_many :incomes
  validates_presence_of :ordernum, :orderdate, :startdate, :finishdate, :status, :ordersum, :employee, :client, :user

  def status_desc
    case self.status
      when 0 then 'Открыт'
      when 1 then 'Закрыт'
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

  def floating_debt(uid)
    months = Time.at(self.finishdate - self.startdate).month + 1
    now = self.startdate
    debtsum = self.ordersum / months
    months.times {
      present_debt = Debt.where(:year => now.year,
                                :month => now.month,
                                :debtsum => debtsum,
                                :employee_id => self.employee_id,
                                :client_id => self.client_id,
                                :order_id => self.id).first
      Debt.create(:year => now.year,
                  :month => now.month,
                  :debtsum => debtsum,
                  :employee_id => self.employee_id,
                  :client_id => self.client_id,
                  :order_id => self.id,
                  :debttype => 0,
                  :user_id => uid) unless present_debt
      now = now + 1.month
    }
  end
end
