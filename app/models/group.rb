class Group < ActiveRecord::Base
  belongs_to :branch
  belongs_to :employee
  belongs_to :user
  validates_presence_of :code
  validates_uniqueness_of :code
end
