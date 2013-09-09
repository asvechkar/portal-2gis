class Debt < ActiveRecord::Base
  belongs_to :employee
  belongs_to :client
  belongs_to :order
  belongs_to :user
  validates_presence_of :year, :month, :employee, :client, :order, :debtsum, :debttype, :user

  def decode_type
    case self.debttype
      when 0
        'план'
      when 1
        'рассрочка'
      when 2
        'дебет'
    end
  end

end
