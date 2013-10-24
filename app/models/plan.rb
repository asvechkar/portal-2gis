class Plan < ActiveRecord::Base
  belongs_to :employee
  belongs_to :user
  validates_presence_of :month, :year, :clients, :employee, :user

  scope :today, ->(user_id) { where('user_id = ? and created_at between ? and ?',
                                    user_id,
                                    DateTime.now.beginning_of_day,
                                    DateTime.now.end_of_day) }
  scope :by_branch, ->(branch) { joins(:employee).where('employees.branch_id = ?', branch) if branch.present? }
  scope :by_group, ->(group) { joins(employee: :groups).where('groups.id = ?', group) if group.present? }
  scope :by_date, ->(date) { where('year = ? and month = ?', date.year, date.month) }

  def weight
    ave_bill = Averagebill.where(branch: self.employee.branch, year: self.year, month: self.month).first
    return ave_bill.nil? ? 0 : self.clients * ave_bill.bill
  end
end
