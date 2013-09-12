class Plancent < ActiveRecord::Base
  belongs_to :branch
  belongs_to :user
  validates_presence_of :year, :month, :branch_id, :fromprc, :toprc, :mult, :user_id
end
