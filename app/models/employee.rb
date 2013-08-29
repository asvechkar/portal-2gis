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
end
