class Income < ActiveRecord::Base
  belongs_to :client
  belongs_to :employee
  belongs_to :order
  belongs_to :user

  validates :indate, :insum, presence: true

  scope :by_manager, ->(id) { where(employee_id: id) }

  class << self
    def filter(params)
      incomes = if params[:branch]
                  employees_ids = Employee.by_branch(params[:branch]).map(&:id)
                  Income.where('id in (?)', employees_ids)
                end
      incomes = if params[:manager]
                  incomes ? incomes.by_manager(params[:manager]) : self.by_manager(params[:manager])
                end
    end
  end
end
