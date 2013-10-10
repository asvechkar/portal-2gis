class Branch < ActiveRecord::Base
  belongs_to :city
  belongs_to :employee
  belongs_to :user
  has_many :groups
  has_many :employees
  has_many :averagebills
  has_many :plancents
  has_many :planfacts, as: :planfactable
  validates_presence_of :name
  validates_uniqueness_of :name
end
