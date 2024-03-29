class Employee < ApplicationRecord
  included User
  mount_uploader :avatar, AvatarUploader

  belongs_to :level
  belongs_to :position
  belongs_to :user
  belongs_to :branch
  belongs_to :account, :class_name => 'User'
  has_many :clients, through: :orders
  has_many :branches
  has_many :groups
  has_many :plans
  has_many :orders
  has_many :debts
  has_many :incomes
  has_many :planfacts, as: :planfactable
  has_many :users, :through => :userifications, :foreign_key => 'userable_id'
  has_many :suspensions
  has_many :groups, :through => :suspensions, :source => :employed, :source_type => 'Group'

  validates_presence_of :firstname, :lastname, :snils # :middlename,

  scope :by_branch, ->(id) { joins(:branches).where('employees.branch_id = ?', id) }
  scope :with_branch, ->(id) { where(branch_id: id) if id }
  scope :with_lastname, ->(lastname) { where("LOWER(lastname) like '%#{lastname}%'")}

  delegate :email, to: :account, allow_nil: true
  delegate :name, to: :position, prefix: true, allow_nil: true

  def initials
    self.lastname + ' ' + self.firstname[0] + '.' + self.middlename[0] + '.'
  end

  def get_new_plan_clients
    plans = Plan.where(:year => Date.today.year, :month => Date.today.month, :employee => self)
    plans.empty? ? 0 : plans.first.clients
  end

  def get_new_fact_clients
    orders = Order.select(:client_id).where(:employee => self, :startdate => Date.today.next_month.at_beginning_of_month).group(:client_id)
    orders.empty? ? 0 : orders.all.count
  end

  def get_fact_clients_by_date date
    orders = Order.select(:client_id).where(:employee => self, :orderdate => date).group(:client_id)
    orders.empty? ? 0 : orders.all.count
  end

  def get_cont_plan_clients
    orders = Order.select(:client_id).where(:employee => self, :continue => 1, :finishdate => Date.today.at_end_of_month).group(:client_id)
    orders.empty? ? 0 : orders.all.count
  end

  def get_new_plan_weight
    plans = Plan.where(:year => Date.today.year, :month => Date.today.month, :employee => self)
    plans.empty? ? 0 : plans.first.weight
  end

  def get_new_fact_weight
    orders = Order.where(:employee => self, :startdate => Date.today.next_month.at_beginning_of_month)
    weight = 0
    unless orders.empty?
      orders.each do |order|
        weight += order.weight
      end
    end
    weight
  end

  def get_fact_weight_by_date date
    orders = Order.where(:employee => self, :orderdate => date)
    weight = 0
    unless orders.empty?
      orders.each do |order|
        weight += order.weight
      end
    end
    weight
  end

  def get_cont_plan_weight
    orders = Order.where(:employee => self, :continue => 1, :finishdate => Date.today.at_end_of_month)
    weight = 0
    unless orders.empty?
      orders.each do |order|
        weight += order.weight
      end
    end
    weight
  end

  def get_installment_sum
    Debt.where(:year => Date.today.year, :month => Date.today.month, :employee => self, :debttype => 1).sum(:debtsum)
  end

  def get_debt_sum
    Debt.where(:year => Date.today.year, :month => Date.today.month, :employee => self, :debttype => 2).sum(:debtsum)
  end

  def get_fact_incomes
    Income.where("indate BETWEEN '#{Date.today.at_beginning_of_month}' AND '#{Date.today.at_end_of_month}' AND employee_id = #{self.id}").sum(:insum)
  end

  def get_incomes_by_date date
    Income.where(:indate => date, :employee => self).sum(:insum)
  end

  def get_prolong_percents
    plan = Order.select(:client_id).where(:employee => self, :finishdate => Date.today.at_end_of_month).group(:client_id)
    fact = Order.select(:client_id).where("employee_id = #{self.id} AND startdate = '#{Date.today.next_month.at_beginning_of_month}' AND order_id IS NOT NULL").group(:client_id)
    if fact.empty?
      0
    else
      if plan.empty?
        0
      else
        ((fact.all.count.to_f / plan.all.count.to_f) * 100).round
      end
    end
  end

  def get_ic
    first = (self.get_new_fact_clients.to_f / (self.get_new_plan_clients + self.get_cont_plan_clients).to_f) * 0.2
    second = (self.get_new_fact_weight.to_f / (self.get_new_plan_weight + self.get_cont_plan_weight).to_f) * 0.3
    third = (self.get_fact_incomes.to_f / (((self.get_new_plan_weight + self.get_cont_plan_weight) * 2.5) + self.get_installment_sum + self.get_debt_sum).to_f) * 0.3
    total = first + second + third
    prolong = self.get_prolong_percents
    mult = Plancent.where("branch_id = #{self.branch_id} AND year = #{Date.today.year} AND month = #{Date.today.month} AND fromprc <= #{prolong} AND toprc >= #{prolong}")
    mult.empty? ? total += 0 : total += mult.first.mult * 0.2
    total
  end

  # By_date
  def get_new_plan_clients_by_date(date)
    plans = Plan.where(year: date.year, month: date.month, employee: self)
    plans.empty? ? 0 : plans.first.clients
  end

  def get_cont_plan_clients_by_date(date)
    orders = Order.select(:client_id).where(employee: self, continue: 1, finishdate: date.at_end_of_month).group(:client_id)
    orders.empty? ? 0 : orders.all.count
  end

  def get_new_fact_clients_by_date(date)
    orders = Order.select(:client_id).where(employee: self, startdate: date.next_month.at_beginning_of_month).group(:client_id)
    orders.empty? ? 0 : orders.all.count
  end

  def get_new_plan_weight_by_date(date)
    plans = Plan.where(year: date.year, month: date.month, employee: self)
    plans.empty? ? 0 : plans.first.weight
  end

  def get_cont_plan_weight_by_date(date)
    orders = Order.where(employee: self, continue: 1, finishdate: date.at_end_of_month)
    weight = 0
    unless orders.empty?
      orders.each do |order|
        weight += order.weight
      end
    end
    weight
  end

  def get_new_fact_weight_by_date(date)
    orders = Order.where(employee: self, startdate: date.next_month.at_beginning_of_month)
    weight = 0
    unless orders.empty?
      orders.each do |order|
        weight += order.weight
      end
    end
    weight
  end

  def get_installment_sum_by_date(date)
    Debt.where(year: date.year, month: date.month, employee: self, debttype: 1).sum(:debtsum)
  end

  def get_debt_sum_by_date(date)
    Debt.where(year: date.year, month: date.month, employee: self, debttype: 2).sum(:debtsum)
  end

  def get_fact_incomes_by_date(date)
    Income.where("indate BETWEEN '#{date.at_beginning_of_month}' AND '#{date.at_end_of_month}' AND employee_id = #{self.id}").sum(:insum)
  end

  def get_prolong_percents_by_date(date)
    plan = Order.select(:client_id).where(employee: self, finishdate: date.at_end_of_month).group(:client_id)
    fact = Order.select(:client_id).where("employee_id = #{self.id} AND startdate = '#{date.next_month.at_beginning_of_month}' AND order_id IS NOT NULL").group(:client_id)
    if fact.empty?
      0
    else
      if plan.empty?
        0
      else
        ((fact.all.count.to_f / plan.all.count.to_f) * 100).round
      end
    end
  end

  def get_ic_by_date(date)
    first = (self.get_new_fact_clients.to_f / (self.get_new_plan_clients + self.get_cont_plan_clients).to_f) * 0.2
    second = (self.get_new_fact_weight.to_f / (self.get_new_plan_weight + self.get_cont_plan_weight).to_f) * 0.3
    third = (self.get_fact_incomes.to_f / (((self.get_new_plan_weight + self.get_cont_plan_weight) * 2.5) + self.get_installment_sum + self.get_debt_sum).to_f) * 0.3
    total = first + second + third
    prolong = self.get_prolong_percents
    mult = Plancent.where("branch_id = #{self.branch_id} AND year = #{date.year} AND month = #{date.month} AND fromprc <= #{prolong} AND toprc >= #{prolong}")
    mult.empty? ? total += 0 : total += mult.first.mult * 0.2
    total
  end
  # ------------------------------ Плановые методы
  # План по новым клиентам
  def plan_new_clients(date)
    plans = Plan.where(year: date.year, month: date.month, employee: self)
    plans.empty? ? 0 : plans.first.clients
  end

  # План по продленным клиентам
  def plan_cont_clients(date)
    orders = Order.select(:client_id).where(:employee => self, :continue => 1, :finishdate => date.at_end_of_month).group(:client_id)
    orders.empty? ? 0 : orders.all.count
  end

  # План по клиентам
  def plan_clients(date)
    plan_new_clients(date) + plan_cont_clients(date)
  end

  # Груз по новым клиентам
  def weight_new_clients(date)
    plans = Plan.where(:year => date.year, :month => date.month, :employee => self)
    plans.empty? ? 0 : plans.first.weight
  end

  # Груз по продленным клиентам
  def weight_cont_clients(date)
    orders = Order.where(:employee => self, :continue => 1, :finishdate => date.at_end_of_month)
    weight = 0
    unless orders.empty?
      orders.each do |order|
        weight += order.weight
      end
    end
    weight
  end

  # Общий груз
  def plan_weight(date)
    weight_new_clients(date) + weight_cont_clients(date)
  end

  # Поступления по новым клиентам
  def incomes_new_clients(date)
    weight_new_clients(date) * self.branch.factor(date).prepay rescue 0
  end

  # Поступления по продленным клиентам
  def incomes_cont_clients(date)
    weight_cont_clients(date) * self.branch.factor(date).prepay rescue 0
  end

  # Плановые поступления
  def plan_incomes(date)
    incomes_new_clients(date) + incomes_cont_clients(date)
  end

  # Процент продлений
  def plan_percent(date)
    self.branch.factor(date).planproc10from rescue 0
  end

  # Рассрочки
  def installments(date)
    Debt.where(year: date.year, month: date.month, employee: self, debttype: 1).sum(:debtsum) rescue 0
  end

  # Дебетовая задолженность
  def debts(date)
    Debt.where(year: date.year, month: date.month, employee: self, debttype: 2).sum(:debtsum) rescue 0
  end

  # ------------------------------ Методы рассчета факта
  # Факт по новым клиентам
  def fact_new_clients(date)
    orders = Order.select(:client_id).where(employee: self, startdate: date.next_month.at_beginning_of_month, order_id: nil).group(:client_id)
    orders.empty? ? 0 : orders.all.count
  end
  
  # Факт по продленным клиентам
  def fact_cont_clients(date)
    orders = Order.select(:client_id).where(employee: self, startdate: date.next_month.at_beginning_of_month).where.not(order_id: nil).group(:client_id)
    orders.empty? ? 0 : orders.all.count
  end
  
  # Факт по клиентам
  def fact_clients(date)
    fact_new_clients(date) + fact_cont_clients(date)
  end
  
  # Фактический груз по новым клиентам
  def fact_weight_new_clients(date)
    total_weight = 0
    Order.where(employee: self, startdate: date.next_month.at_beginning_of_month, order_id: nil).each do |order|
      total_weight += order.weight
    end
    return total_weight
  end
  
  # Фактический груз по продленным клиентам
  def fact_weight_cont_clients(date)
    total_weight = 0
    Order.where(employee: self, startdate: date.next_month.at_beginning_of_month).where.not(order_id: nil).each do |order|
      total_weight += order.weight
    end
    return total_weight
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
    Income.where("indate BETWEEN '#{date.at_beginning_of_month}' AND '#{date.at_end_of_month}' AND employee_id = #{self.id}").sum(:insum)
  end
  
  # Фактический процент продлений
  def fact_percent(date)
    plan = self.clients.where('orders.finishdate = ?', date.at_end_of_month).count
    fact = self.clients.where('orders.startdate = ? and order_id is not NULL', date.next_month.at_beginning_of_month).count
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
  plan_percent
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
  fact_percent
  ik
  ).each do |meth|
    define_method("#{meth}_current") { send(meth, Date.today) }
  end

end
