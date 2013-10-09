class Debt < ActiveRecord::Base
  belongs_to :employee
  belongs_to :client
  belongs_to :order
  belongs_to :user
  validates_presence_of :year, :month, :debtsum, :debttype, :user # , :employee, :client, :order,

  scope :today, ->(user_id) { where('user_id = ? and created_at between ? and ?',
                                    user_id,
                                    DateTime.now.beginning_of_day,
                                    DateTime.now.end_of_day) }

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
  
  def self.type_list
    {
      'План' => 0,
      'Рассрочка' => 1,
      'Дебет' => 2
    }
  end

end
