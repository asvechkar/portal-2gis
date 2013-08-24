class Employee < ActiveRecord::Base
  belongs_to :level
  belongs_to :position
  belongs_to :user
  has_many :branches
  has_many :groups
  has_many :plans
  validates_presence_of :firstname, :middlename, :lastname, :snils
  validates_uniqueness_of :firstname, :middlename, :lastname, :snils
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
