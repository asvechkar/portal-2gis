class RemoveColumnFromPlan < ActiveRecord::Migration
  def change
    remove_column :plans, :weight, :string
    remove_column :plans, :total, :string
  end
end
