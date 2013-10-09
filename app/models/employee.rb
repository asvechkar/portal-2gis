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
  has_many :users, :through => :userifications, :foreign_key => 'userable_id'
  has_many :suspensions
  has_many :groups, :through => :suspensions, :source => :employed, :source_type => 'Group'
  
  validates_presence_of :firstname, :lastname, :snils # :middlename,

  scope :by_branch, ->(id) { joins(:branches).where('employees.branch_id = ?', id) }

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
    if mult.empty?
      total += 0
    else
      total += mult.first.mult * 0.2
    end
    total
  end
end
