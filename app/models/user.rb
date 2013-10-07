class User < ActiveRecord::Base
  rolify
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable
  has_many :cities
  has_many :levels
  has_many :positions
  has_many :clients
  has_many :employees
  has_many :branches
  has_many :groups
  has_many :plans
  has_many :orders
  has_many :userifications
  has_many :debts
  has_many :uploads
  has_many :averagebills
  has_many :incomes
  has_many :eventlogs
  has_many :plancents
  has_one :account_employee, :class_name => 'Employee', :foreign_key => 'account_id'
  has_and_belongs_to_many :roles,
                          :join_table => :users_roles,
                          :foreign_key => 'user_id',
                          :association_foreign_key => 'role_id'
  def is?(role)
    roles.include?(role.to_s)
  end

  def role
    self.roles.all.first
  end

  # проверяем принадлежит ли пользователь роли с именем 'admin'
  def is_admin?
    (role.name == 'admin') ? true : false
  end

  # отбор городов доступных текущему пользователю
  def get_cities
    (is_admin?) ? City.all : self.account_employee.presence
  end

  # отбор филиалов доступных текущему пользователю
  def get_branches
    (is_admin?) ? Branch.all : self.account_employee.presence
  end

  # отбор поступлений доступных текущему пользователю (belongs_to)
  def get_incomes
    (is_admin?) ? User.all : self.account_employee.id.presence
  end

  # отбор планов доступных текущему пользователю (belongs_to)
  def get_plans
    (is_admin?) ? User.all : self.account_employee.id.presence
  end

  def city
    self.account_employee ? self.account_employee.branch.name : 'неизвестно'
  end

end
