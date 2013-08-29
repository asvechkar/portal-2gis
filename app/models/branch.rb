class Branch < ActiveRecord::Base
  belongs_to :city
  belongs_to :employee
  belongs_to :user
  has_many :groups
  has_many :averagebills
  validates_presence_of :name
  validates_uniqueness_of :name
end
