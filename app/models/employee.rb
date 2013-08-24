class Employee < ActiveRecord::Base
  belongs_to :level
  belongs_to :position
  belongs_to :user
  has_many :branches
  has_many :groups
  has_many :plans
  validates_presence_of :firstname, :middlename, :lastname, :snils
  validates_uniqueness_of :firstname, :middlename, :lastname, :snils

  def initials
    self.lastname + ' ' + self.firstname[0] + '.' + self.middlename[0] + '.'
  end
end
