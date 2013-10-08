class Plan < ActiveRecord::Base
  belongs_to :employee
  belongs_to :user
  validates_presence_of :month, :year, :clients, :employee, :user

  scope :today, ->(user_id) { where('user_id = ? and created_at between ? and ?',
                                    user_id,
                                    DateTime.now.beginning_of_day,
                                    DateTime.now.end_of_day) }

  def weight
    ave_bill = Averagebill.where(branch_id: self.employee.branch_id, year: self.year, month: self.month).first
    return ave_bill.nil? ? 0 : self.clients * ave_bill.bill
  end
end
