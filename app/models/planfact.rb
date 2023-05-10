class Planfact < ApplicationRecord
  belongs_to :planfactable, polymorphic: true

  #validates_presence_of :report_date, :clients_plan, :clients_fact, :weight_plan, :weight_fact, :income_plan, :income_fact,
  #:pro_percent, :employee_ic, :group_ic, :branch_ic

end
