class User < ActiveRecord::Base
  rolify
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
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
  has_many :employees, :through => :userifications, :source => :userable, :source_type => 'Employee'
  has_many :debts
  has_many :uploads
  has_many :averagebills
  has_many :incomes
  has_many :eventlogs
  has_many :plancents
  has_and_belongs_to_many :roles,
                          :join_table => :users_roles,
                          :foreign_key => 'user_id',
                          :association_foreign_key => 'role_id'
  before_create :set_role

  def is?(role)
    roles.include?(role.to_s)
  end

  def role
    self.roles.all.first
  end
  
  private
    def set_role
      if self.roles.empty?
        self.roles << Role.find_by_name('noob')
      end
    end
end
