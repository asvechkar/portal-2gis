class CreateAveragebills < ActiveRecord::Migration[5.2]
  def change
    create_table :averagebills do |t|
      t.integer :year, :null => false
      t.integer :month, :null => false
      t.float :bill, precision: 10, scale: 2, :null => false
      t.references :user, index: true
      t.references :branch, index: true

      t.timestamps
    end
  end
end
