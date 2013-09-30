class AddAccountToEmployees < ActiveRecord::Migration
  def change
    add_reference :employees, :account, index: true
  end
end
