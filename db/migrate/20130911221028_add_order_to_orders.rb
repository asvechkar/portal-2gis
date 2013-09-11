class AddOrderToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :order, index: true
  end
end
