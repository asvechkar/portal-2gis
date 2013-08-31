class User < ActiveRecord::Base
  rolify
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
  has_and_belongs_to_many :roles, :join_table => :users_roles
end
