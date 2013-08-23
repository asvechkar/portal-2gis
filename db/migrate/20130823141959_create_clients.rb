class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :inn, :null => false
      t.string :code, :null => false
      t.string :name, :null => false
      t.references :city, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
