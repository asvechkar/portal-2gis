class User < ActiveRecord::Base
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
  has_many :userifications
  has_many :employees, :through => :userifications, :source => :userable, :source_type => 'Employee'
end
