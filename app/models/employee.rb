class Employee < ActiveRecord::Base
  belongs_to :level
  belongs_to :position
  belongs_to :user
  belongs_to :branch
  has_many :branches
  has_many :groups
  has_many :plans
  has_many :orders
  has_many :debts
  has_many :incomes
  validates_presence_of :firstname, :lastname,  :snils # :middlename,
  # validates_uniqueness_of :firstname, :lastname, :middlename, :snils
  has_many :userifications, :as => :userable, :dependent => :destroy
  has_many :users, :through => :userifications, :foreign_key => 'userable_id'
  has_many :suspensions
  has_many :groups, :through => :suspensions, :source => :employed, :source_type => 'Group'

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
    return weight
  end

  def get_cont_plan_weight
    orders = Order.where(:employee => self, :continue => 1, :finishdate => Date.today.at_end_of_month)
    weight = 0
    unless orders.empty?
      orders.each do |order|
        weight += order.weight
      end
    end
    return weight
  end

  def get_installment_sum
    instsum = Debt.where(:year => Date.today.year, :month => Date.today.month, :employee => self, :debttype => 1).sum(:debtsum)
    return instsum
  end

  def get_debt_sum
    debtsum = Debt.where(:year => Date.today.year, :month => Date.today.month, :employee => self, :debttype => 2).sum(:debtsum)
    return debtsum
  end

  def get_fact_incomes
    return Income.where("indate BETWEEN '#{Date.today.at_beginning_of_month}' AND '#{Date.today.at_end_of_month}' AND employee_id = #{self.id}").sum(:insum)
  end
end
