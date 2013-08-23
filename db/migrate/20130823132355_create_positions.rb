class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :name, :null => false
      t.references :user, index: true

      t.timestamps
    end
  end
end
