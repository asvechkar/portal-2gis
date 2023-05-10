class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.integer :year, :null => false
      t.integer :month, :null => false
      t.integer :clients, :null => false
      t.float :weight, precision: 10, scale: 2, :null => false
      t.float :total, precision: 10, scale: 2, :null => false
      t.references :employee, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
