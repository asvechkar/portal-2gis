class Client < ActiveRecord::Base
  belongs_to :city
  belongs_to :user
  validates_presence_of :name, :inn, :code
  validates_uniqueness_of :name, :inn, :code
end
