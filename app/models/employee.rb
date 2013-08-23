class Employee < ActiveRecord::Base
  belongs_to :level
  belongs_to :position
  belongs_to :user
  validates_presence_of :firstname, :middlename, :lastname, :snils
  validates_uniqueness_of :firstname, :middlename, :lastname, :snils
end
