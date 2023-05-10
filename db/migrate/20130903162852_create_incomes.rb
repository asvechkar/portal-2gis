class CreateIncomes < ActiveRecord::Migration[5.2]
  def change
    create_table :incomes do |t|
      t.datetime :indate, :null => false
      t.references :client, index: true
      t.float :insum, precision: 10, scale: 2, :null => false
      t.references :employee, index: true
      t.boolean :cash
      t.references :order, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
