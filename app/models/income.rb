class Income < ActiveRecord::Base
  belongs_to :client
  belongs_to :employee
  belongs_to :order
  belongs_to :user

  validates :indate, :insum, presence: true

end
