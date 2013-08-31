class Plan < ActiveRecord::Base
  belongs_to :employee
  belongs_to :user
  validates_presence_of :month, :year, :clients, :employee, :user
end
