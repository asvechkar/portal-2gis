class Client < ApplicationRecord
  belongs_to :city
  belongs_to :user
  has_many :orders
  has_many :debts
  has_many :incomes
  validates_presence_of :name, :code

  scope :today, ->(user_id) { where('user_id = ? and created_at between ? and ?',
                                    user_id,
                                    DateTime.now.beginning_of_day,
                                    DateTime.now.end_of_day) }
end
