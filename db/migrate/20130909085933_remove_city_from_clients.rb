class RemoveCityFromClients < ActiveRecord::Migration
  def change
    remove_reference :clients, :city, index: true
  end
end
