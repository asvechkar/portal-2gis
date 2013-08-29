module PlansHelper
  def get_plan_weight plan
    ave_bill = Averagebill.where(branch_id: plan.employee.branch_id, year: plan.year, month: plan.month).first
    if ave_bill
      plan.clients * ave_bill.bill
    else
      0
    end
  end
end
