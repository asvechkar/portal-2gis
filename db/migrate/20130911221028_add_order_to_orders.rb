class AddOrderToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :order, index: true
  end
end
