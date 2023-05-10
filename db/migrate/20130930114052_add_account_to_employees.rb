class AddAccountToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_reference :employees, :account, index: true
  end
end
