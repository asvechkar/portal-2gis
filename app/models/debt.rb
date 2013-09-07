class Debt < ActiveRecord::Base
  belongs_to :employee
  belongs_to :client
  belongs_to :order
  belongs_to :user
  validates_presence_of :year, :month, :employee, :client, :order, :debtsum, :debttype, :user



end
