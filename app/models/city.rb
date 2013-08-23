class City < ActiveRecord::Base
  belongs_to :user
  has_many :clients
  validates_presence_of :name
  validates_uniqueness_of :name
end
