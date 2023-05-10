class CreateDebts < ActiveRecord::Migration[5.2]
  def change
    create_table :debts do |t|
      t.integer :year, :null => false
      t.integer :month, :null => false
      t.references :employee, index: true
      t.references :client, index: true
      t.references :order, index: true
      t.float :debtsum, precision: 10, scale: 2, :null => false
      t.integer :debttype, :null => false
      t.references :user, index: true

      t.timestamps
    end
  end
end
