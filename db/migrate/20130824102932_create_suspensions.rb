class CreateSuspensions < ActiveRecord::Migration[5.2]
  def change
    create_table :suspensions do |t|
      t.belongs_to :employee
      t.belongs_to :employed, polymorphic: true
    end
    add_index :suspensions, [:employed_id, :employed_type, :employee_id], :name => 'suspensions_index'
  end
end
