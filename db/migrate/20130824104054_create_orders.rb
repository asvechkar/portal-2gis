class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :ordernum, :null => false
      t.datetime :orderdate, :null => false
      t.datetime :startdate, :null => false
      t.datetime :finishdate, :null => false
      t.integer :status, :null => false
      t.float :ordersum, precision: 10, scale: 2, :null => false
      t.integer :continue, :null => false
      t.references :employee, index: true
      t.references :client, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
