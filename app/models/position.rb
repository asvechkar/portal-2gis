class Position < ActiveRecord::Base
  belongs_to :user
  has_many :employees
  validates_presence_of :name
  validates_uniqueness_of :name
end
