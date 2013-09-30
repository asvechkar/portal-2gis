class Userification < ActiveRecord::Base
  belongs_to :userable, :polymorphic => true
  belongs_to :user
  has_many :employees, :through => :userifications, :foreign_key => 'employed_id'
end
