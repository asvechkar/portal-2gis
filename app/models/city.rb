class City < ActiveRecord::Base
  belongs_to :user
  has_many :clients
  has_many :branches
  has_many :orders
  validates_presence_of :name
  validates_uniqueness_of :name
end
