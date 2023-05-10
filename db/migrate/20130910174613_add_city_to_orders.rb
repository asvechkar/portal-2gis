class AddCityToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :city, index: true
  end
end
