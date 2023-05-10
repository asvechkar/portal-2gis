class RemoveColumnFromPlan < ActiveRecord::Migration[5.2]
  def change
    remove_column :plans, :weight, :string
    remove_column :plans, :total, :string
  end
end
