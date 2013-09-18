class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :birthdate, :date
    add_column :users, :gender, :boolean
    add_column :users, :about, :text
    add_column :users, :phone, :string
    add_column :users, :site, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :skype, :string
  end
end
