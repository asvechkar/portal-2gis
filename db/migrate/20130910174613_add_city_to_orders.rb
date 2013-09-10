class AddCityToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :city, index: true
  end
end
