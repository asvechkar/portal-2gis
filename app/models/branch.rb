class Branch < ActiveRecord::Base
  belongs_to :city
  belongs_to :employee
  belongs_to :user
  has_many :groups
  has_many :employees
  has_many :averagebills
  has_many :plancents
  has_many :planfacts, as: :planfactable
  has_many :factors
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # ------------------------------ Новые методы
  # План по новым клиентам
  def plan_new_clients(date)
    plan = 0
    self.groups.each do |group|
      plan += group.plan_new_clients(date)
    end
    plan
  end
  
  # План по новым клиентам текущий
  def plan_new_clients_current
    plan_new_clients(Date.today)
  end
  
  # План по продленным клиентам
  def plan_cont_clients(date)
    plan = 0
    self.groups.each do |group|
      plan += group.plan_cont_clients(date)
    end
    plan
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
    plan = 0
    self.groups.each do |group|
      plan += group.weight_new_clients(date)
    end
    plan
  end
  
  # Груз по новым клиентам текущий
  def weight_new_clients_current
    weight_new_clients(Date.today)
  end
  
  # Груз по продленным клиентам
  def weight_cont_clients(date)
    plan = 0
    self.groups.each do |group|
      plan += group.weight_cont_clients(date)
    end
    plan
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
    Plancent.where(branch_id: self.id, year: date.year, month: date.month, mult: 1.0).first.fromprc rescue 0
  end
  
  # Процент продлений текуший
  def cont_percent_current
    cont_percent(Date.today)
  end
  
  # Интегральный коэффициент
  def ik(date)
    return 0
  end

  # Интегральный коэффициент текущий
  def ik_current
    ik(Date.today)
  end

end
