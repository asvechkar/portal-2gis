class Client < ActiveRecord::Base
  belongs_to :city
  belongs_to :user
  has_many :orders
  has_many :debts
  has_many :incomes
  validates_presence_of :name, :code, :inn, :city_id
  validates_uniqueness_of :name, :code, :inn
end
