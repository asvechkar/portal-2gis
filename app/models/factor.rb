class Factor < ApplicationRecord
  belongs_to :branch
  belongs_to :user
  validates_presence_of :branch


end
