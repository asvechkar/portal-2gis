class CreatePlanfacts < ActiveRecord::Migration
  def change
    create_table :planfacts do |t|
      t.date :report_date
      t.integer :planfactable_id
      t.string :planfactable_type
      t.integer :clients_plan
      t.integer :clients_fact
      t.float :weight_plan
      t.float :weight_fact
      t.float :income_plan
      t.float :income_fact
      t.float :pro_percent
      t.float :employee_ic
      t.float :group_ic
      t.float :branch_ic

      t.timestamps
    end
  end
end
