class RemoveCityFromClients < ActiveRecord::Migration[5.2]
  def change
    remove_reference :clients, :city, index: true
  end
end
