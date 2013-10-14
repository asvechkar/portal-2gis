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

  def city
    self.account_employee ? self.account_employee.branch.name : 'неизвестно'
  end

  # scope :free, where(account_employee: nil)

  Role.all.each do |role|
    define_method("is_#{role.name}?"){ self.role.name == role.name }
    define_method("is_not_#{role.name}?"){ self.role.name != role.name }
  end

end
