class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :firstname, :null => false
      t.string :middlename, :null => false
      t.string :lastname, :null => false
      t.string :snils, :null => false
      t.references :level, index: true
      t.references :position, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
