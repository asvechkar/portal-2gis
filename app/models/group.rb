class Group < ActiveRecord::Base
  belongs_to :branch
  #belongs_to :employee
  belongs_to :user
  has_many :suspensions, :as => :employed, :dependent => :destroy
  has_many :employees, :through => :suspensions, :foreign_key => 'employed_id'
  validates_presence_of :code
  validates_uniqueness_of :code
end
