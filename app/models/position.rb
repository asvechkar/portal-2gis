class Position < ApplicationRecord
  belongs_to :user
  has_many :employees
  validates_presence_of :name
  validates_uniqueness_of :name
end
