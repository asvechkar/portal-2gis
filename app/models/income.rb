class Income < ActiveRecord::Base
  belongs_to :client
  belongs_to :employee
  belongs_to :order
  belongs_to :user
  validates_presence_of :indate, :insum
end
