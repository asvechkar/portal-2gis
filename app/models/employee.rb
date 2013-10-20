class Employee < ActiveRecord::Base
  included User
  mount_uploader :avatar, AvatarUploader

  belongs_to :level
  belongs_to :position
  belongs_to :user
  belongs_to :branch
  belongs_to :account, :class_name => 'User'

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

  delegate :email, to: :user, allow_nil: true
  delegate :name, to: :position, prefix: true, allow_nil: true

  def group
    self
  end

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
  # ------------------------------ Новые методы
  # План по новым клиентам
  def plan_new_clients(date)
    plans = Plan.where(year: date.year, month: date.month, employee: self)
    plans.empty? ? 0 : plans.first.clients
  end
  
  # План по новым клиентам текущий
  def plan_new_clients_current
    plan_new_clients(Date.today)
  end
  
  # План по продленным клиентам
  def plan_cont_clients(date)
    orders = Order.select(:client_id).where(:employee => self, :continue => 1, :finishdate => date.at_end_of_month).group(:client_id)
    orders.empty? ? 0 : orders.all.count
  end
  
  # План по продленным клиентам текущий
  def plan_cont_clients_current
    plan_cont_clients(Date.today)
  end
  
  # План по клиентам
  def plan_clients(date)
    plan_new_clients(date) + plan_cont_clients(date)
  end
  
  # План по клиентам текущий
  def plan_clients_current
    plan_clients(Date.today)
  end
  
  # Груз по новым клиентам
  def weight_new_clients(date)
    plans = Plan.where(:year => date.year, :month => date.month, :employee => self)
    plans.empty? ? 0 : plans.first.weight
  end
  
  # Груз по новым клиентам текущий
  def weight_new_clients_current
    weight_new_clients(Date.today)
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
  
  # Груз по продленным клиентам текущий
  def weight_cont_clients_current
    weight_cont_clients(Date.today)
  end
  
  # Поступления по новым клиентам
  def incomes_new_clients(date)
    weight_new_clients(date) * 2.5
  end
  
  # Поступления по новым клиентам текущий
  def incomes_new_clients_current
    incomes_new_clients(Date.today)
  end
  
  # Поступления по продленным клиентам
  def incomes_cont_clients(date)
    weight_cont_clients(date) * 2.5
  end
  
  # Поступления по продленным клиентам текущий
  def incomes_cont_clients_current
    incomes_cont_clients(Date.today)
  end
  
  # Процент продлений
  def cont_percent(date)
    Plancent.where(brach_id: self.branch, year: date.year, month: date.month, mult: 1.0).first.fromprc rescue 0
  end
  
  # Процент продлений текуший
  def cont_percent_current
    cont_percent(Date.today)
  end
  
  # Интегральный коэффициент
  def ik(date)
  end

end
