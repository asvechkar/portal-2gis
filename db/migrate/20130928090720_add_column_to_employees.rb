class AddColumnToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :birthdate, :date
    add_column :employees, :gender, :boolean
    add_column :employees, :about, :text
    add_column :employees, :phone, :string
    add_column :employees, :site, :string
    add_column :employees, :facebook, :string
    add_column :employees, :twitter, :string
    add_column :employees, :skype, :string
    add_column :employees, :vkontakte, :string
  end
end
