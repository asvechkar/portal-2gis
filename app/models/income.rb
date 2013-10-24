class Income < ActiveRecord::Base
  belongs_to :client
  belongs_to :employee
  belongs_to :order
  belongs_to :user

  validates :indate, :insum, presence: true

  scope :by_branch, ->(branch) { joins(:employee).where('employees.branch_id = ?', branch) if branch.present? }
  scope :by_employee, ->(employee) { where(employee_id: employee) if employee.present? }

end
