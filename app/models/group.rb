class Group < ActiveRecord::Base
  belongs_to :branch
  belongs_to :employee
  belongs_to :user
  has_many :planfacts, as: :planfactable
  has_many :suspensions, :as => :employed, :dependent => :destroy
  has_many :employees, :through => :suspensions, :foreign_key => 'employed_id'
  validates_presence_of :code
  validates_uniqueness_of :code
  
  # ------------------------------ Новые методы
  # План по новым клиентам
  def plan_new_clients(date)
    self.employees.inject(0) { |sum, employee| sum += employee.plan_new_clients(date) }
  end
  
  # План по продленным клиентам
  def plan_cont_clients(date)
    self.employees.inject(0) { |sum, employee| sum += employee.plan_cont_clients(date) }
  end
  
  # План по клиентам
  def plan_clients(date)
    plan_new_clients(date) + plan_cont_clients(date)
  end
  
  # Груз по новым клиентам
  def weight_new_clients(date)
    self.employees.inject(0) { |sum, employee| sum += employee.weight_new_clients(date) }
  end
  
  # Груз по продленным клиентам
  def weight_cont_clients(date)
    self.employees.inject(0) { |sum, employee| sum += employee.weight_cont_clients(date) }
  end

  # Общий груз
  def plan_weight(date)
    weight_new_clients(date) + weight_cont_clients(date)
  end
  
  # Поступления по новым клиентам
  def incomes_new_clients(date)
    weight_new_clients(date) * 2.5
  end
  
  # Поступления по продленным клиентам
  def incomes_cont_clients(date)
    weight_cont_clients(date) * 2.5
  end

  # Плановые поступления
  def plan_incomes(date)
    incomes_new_clients(date) + incomes_cont_clients(date)
  end
  
  # Процент продлений
  def cont_percent(date)
    self.branch.factor(date).planproc10from rescue 0
  end
  
  # Рассрочки
  def installments(date)
    self.employees.inject(0) { |sum, employee| sum += employee.installments(date) }
  end

  # Дебетовая задолженность
  def debts(date)
    self.employees.inject(0) { |sum, employee| sum += employee.debts(date) }
  end
  
  # ------------------------------ Методы рассчета факта
  # Факт по новым клиентам
  def fact_new_clients(date)
    self.employees.inject(0) { |sum, employee| sum += employee.fact_new_clients(date) }
  end
  
  # Факт по продленным клиентам
  def fact_cont_clients(date)
    self.employees.inject(0) { |sum, employee| sum += employee.fact_cont_clients(date) }
  end
  
  # Факт по клиентам
  def fact_clients(date)
    fact_new_clients(date) + fact_cont_clients(date)
  end
  
  # Фактический груз по новым клиентам
  def fact_weight_new_clients(date)
    self.employees.inject(0) { |sum, employee| sum += employee.fact_weight_new_clients(date) }
  end
  
  # Фактический груз по продленным клиентам
  def fact_weight_cont_clients(date)
    self.employees.inject(0) { |sum, employee| sum += employee.fact_weight_cont_clients(date) }
  end
  
  # Фактический груз
  def fact_weight(date)
    fact_weight_new_clients(date) + fact_weight_cont_clients(date)
  end
  
  # Фактические поступления по новым клиентам
  def fact_incomes_new_clients(date)
    return 0
  end
  
  # Фактические поступления по продленным клиентам
  def fact_incomes_cont_clients(date)
    return 0
  end
  
  # Фактические поступления
  def fact_incomes(date)
    self.employees.inject(0) { |sum, employee| sum += employee.fact_incomes(date) }
  end
  
  # Фактический процент продлений
  def fact_percent(date)
    plan = 0
    fact = 0
    self.employees.inject(0) { |plan, employee| plan += employee.clients.where('orders.finishdate = ?', date.at_end_of_month).count }
    self.employees.inject(0) { |fact, employee| fact += employee.clients.where('orders.startdate = ? and order_id is not NULL', date.next_month.at_beginning_of_month).count }
    fact == 0 ? 0 : ((fact / plan) * 100).round
  end
  
  # Интегральный коэффициент
  def ik(date)
    client_ik = fact_clients(date) / plan_clients(date) * self.branch.factor(date).client rescue 0
    weight_ik = fact_weight(date) / plan_weight(date) * self.branch.factor(date).weight rescue 0
    incomes_ik = fact_incomes(date) / (plan_incomes(date) + installments(date) + debts(date)) * self.branch.factor(date).incomes rescue 0
    total_ik = client_ik + weight_ik + incomes_ik
    prolong = fact_percent(date)
    total_ik += self.branch.mult(date, prolong) * self.branch.factor(date).prolongcent rescue 0
    total_ik
  end
  
  # Добавление текущего вывода показателей
  %w(
  plan_new_clients
  plan_cont_clients
  plan_clients
  weight_new_clients
  weight_cont_clients
  plan_weight
  incomes_new_clients
  incomes_cont_clients
  plan_incomes
  cont_percent
  installments
  fact_new_clients
  fact_cont_clients
  fact_clients
  fact_weight_new_clients
  fact_weight_cont_clients 
  fact_weight 
  fact_incomes_new_clients 
  fact_incomes_cont_clients 
  fact_incomes 
  ik
  ).each do |meth|
    define_method("#{meth}_current") { send(meth, Date.today) }
  end
end
