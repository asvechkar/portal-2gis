class AddColumnToEmployee < ActiveRecord::Migration
  def change
    add_reference :employees, :branch, index: true
  end
end
