class AddColumnToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_reference :employees, :branch, index: true
  end
end
