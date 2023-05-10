class Averagebill < ApplicationRecord
  belongs_to :user
  belongs_to :branch
  validates_presence_of :year, :month, :branch_id, :bill
end
